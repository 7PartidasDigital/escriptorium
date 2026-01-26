#' Anotación automática de folios en archivos PAGE-XML
#'
#' Añade marcadores normalizados de folio recto (`[fol. r]{CB1.`) y verso 
#' (`[fol. v]{CB1.`) al inicio del texto de las dos primeras regiones textuales
#' (`<TextRegion>`) de un archivo XML. Sobrescribe el archivo original por defecto.
#'
#' @param infile \code{character(1)}. Ruta al archivo XML de entrada.
#' @param outfile \code{character(1)}. Ruta al archivo XML de salida. 
#'   Por defecto, sobrescribe \code{infile}.
#'
#' @details 
#' El script localiza todas las etiquetas `<TextRegion>` y modifica el contenido 
#' de sus primeras etiquetas `<Unicode>` internas:
#' 
#' \itemize{
#'   \item Primera región: `[fol. v]{CB1.` + texto original
#'   \item Segunda región: `[fol. r]{CB1.` + texto original
#' }
#' 
#' Emite advertencia si el documento tiene menos de 2 regiones textuales.
#'
#' @return \code{NULL} (escribe archivo modificado).
#'
#' @examples
#' # Procesar archivo individual
#' anotar_folios("manuscrito_001.xml")
#' 
#' # Procesar en lote (ejemplo)
#' files <- list.files(pattern = "^0.*_BNF_1510_.*\\.xml$")
#' sapply(files, anotar_folios)
#'
#' @export

library(xml2)

anotar_folios <- function(infile, outfile = infile) {
  doc <- read_xml(infile)
  
  regions <- xml_find_all(doc, ".//*[local-name() = 'TextRegion']")
  n_reg   <- length(regions)
  
  # Mensaje si hay menos de 2 regiones
  if (n_reg < 2) {
    message("ATENCIÓN: ", infile, " solo tiene ", n_reg, " TextRegion")
  }
  
  if (n_reg >= 1) {
    first_region  <- regions[[1]]
    first_unicode <- xml_find_first(first_region, ".//*[local-name() = 'Unicode']")
    if (!is.na(first_unicode)) {
      old_text <- xml_text(first_unicode)
      xml_set_text(first_unicode, paste0("[fol. v]{CB1.", old_text))
    }
  }
  
  if (n_reg >= 2) {
    second_region  <- regions[[2]]
    second_unicode <- xml_find_first(second_region, ".//*[local-name() = 'Unicode']")
    if (!is.na(second_unicode)) {
      old_text <- xml_text(second_unicode)
      xml_set_text(second_unicode, paste0("[fol. r]{CB1.", old_text))
    }
  }
  
  write_xml(doc, outfile)
}

# Aplicación en lote
setwd("/ruta/a/tus/xml")
files <- list.files()

for (f in files) {
  anotar_folios(f, outfile = f)
}
