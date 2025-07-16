# Cargar librerías
library(xml2)
library(magick)
library(tools)  # Para file_path_sans_ext

# ----- Configuración del directorio -----
input_dir <- "."        # Cambia si los archivos no están en el working directory
output_dir <- "resultado"
if (!dir.exists(output_dir)) dir.create(output_dir)

# Patrón regex para tierra/tierras (insensible a mayúsculas) y singular/plural
# Esto es lo más chungo
palabra <- "\\b[tT][iI][eE][rR][rR]?[aA][sS]?\\b"

# ------ Función para procesar cada par XML/JPEG ------
process_file_pair <- function(xml_path, img_path, regex_pat, output_dir, ns) {
  # Leer el XML
  xml_doc <- read_xml(xml_path)
  img     <- image_read(img_path)
  
  # Buscar todos los nodos <TextLine>
  textlines <- xml_find_all(xml_doc, ".//pc:TextLine", ns)
  
  # Filtrar líneas cuyo <Unicode> contiene el patrón buscado
  lines_with_match <- Filter(function(line) {
    unicode_node <- xml_find_first(line, ".//pc:TextEquiv/pc:Unicode", ns)
    if (!is.na(unicode_node)) {
      unicode_text <- xml_text(unicode_node)
      # Limpiar los símbolos ⊂ y ⊃ se pueden incluir otros símbolos si es necesario
      unicode_text_clean <- gsub("[⊂⊃]", "", unicode_text)
      grepl(regex_pat, unicode_text_clean, ignore.case = TRUE, perl = TRUE)
    } else {
      FALSE
    }
  }, textlines)
  
  # Extraer base del nombre de archivo (sin extensión)
  basefilename <- file_path_sans_ext(basename(xml_path))
  
  # Procesar cada recorte
  for (line in lines_with_match) {
    tr_id <- xml_attr(xml_parent(line), "id")
    tl_id <- xml_attr(line, "id")
    coords_node <- xml_find_first(line, ".//pc:Coords", ns)
    coords_string <- xml_attr(coords_node, "points")
    
    # Extraer coordenadas poligonales
    coords <- {
      pares <- strsplit(coords_string, " ")[[1]]
      do.call(rbind, lapply(pares, function(par) as.numeric(strsplit(par, ",")[[1]])))
    }
    
    # Bounding box con margen
    min_x <- min(coords[, 1]) - 15
    max_x <- max(coords[, 1]) + 15
    min_y <- min(coords[, 2])
    max_y <- max(coords[, 2])
    ancho <- max_x - min_x
    alto  <- max_y - min_y
    min_x <- max(0, min_x)
    min_y <- max(0, min_y)
    
    # Nombre de salida: basefilename_tr_id_tl_id.jpg
    out_name <- sprintf("%s/%s_%s_%s.jpg", output_dir, basefilename, tr_id, tl_id)
    
    # Recortar y guardar
    geometry <- geometry_area(width = ancho, height = alto, x_off = min_x, y_off = min_y)
    cropped <- image_crop(img, geometry)
    image_write(cropped, path = out_name)
  }
  cat(sprintf("Procesado: %s / Coincidencias: %d\n", basefilename, length(lines_with_match)))
}

# ----- LISTAR Y PROCESAR TODOS LOS PARES DEL DIRECTORIO -----

# Busca archivos XML y JPEG con el mismo nombre base en el input_dir
xml_files <- list.files(path = input_dir, pattern = "\\.xml$", full.names = TRUE)
jpeg_files <- list.files(path = input_dir, pattern = "\\.jpe?g$", full.names = TRUE)

# Definir el namespace para PAGE XML (ajusta si tu namespace es diferente)
page_ns <- c(pc = "http://schema.primaresearch.org/PAGE/gts/pagecontent/2019-07-15")

# Procesa sólo los pares que tienen XML y JPEG asociados por nombre base
for (xml_file in xml_files) {
  base <- file_path_sans_ext(basename(xml_file))
  # Busca si existe un JPEG asociado al mismo nombre base
  img_file <- jpeg_files[tools::file_path_sans_ext(basename(jpeg_files)) == base]
  if (length(img_file) > 0) {
    process_file_pair(xml_file, img_file[1], palabra, output_dir, page_ns)
  }
}
cat("✅ Procesamiento completado para todos los archivos.\n")
