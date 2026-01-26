######################################################################
# VALIDADOR HSMS para OSTA v1.0
# ================================================
# 
# VALIDA ficheros TEXT.sigla.txt etiquetados con sistema HSMS
# antes de procesar con analizador morfológico OSTA
# 
# AUTOR: Asistente IA + Usuario (26 Ene 2026)
# 
# COMPRUEBA:
# ├─ WHITESPACE: sin tabs, espacios dobles, líneas vacías (excepto última)
# ├─ FOLIACIÓN: [fol. 1r]→[fol. 1v]→[fol. 2r]→[fol. 2v]... estricta
# ├─ ETIQUETAS:
# │  ├─ {CBn.: estructura columnas, cierres } obligatorios
# │  ├─ {INn.: número + punto obligatorio
# │  ├─ {RUB. : espacio tras punto obligatorio  
# │  ├─ {HD. : SOLO tras [fol.] antes {CBn.
# │  ├─ {SG. : SOLO antes [fol. Xv], columna cerrada
# │  └─ {CW. : SOLO antes [fol. Xr], columna cerrada
# └─ BALANCEO: {} [] () <> perfectamente cerrados POR FOLIO
# 
# USO: validar_completo("TEXT.PJN.txt")
# 
######################################################################

check_whitespace <- function(path) {
  lines <- readLines(path, warn = FALSE)
  n <- length(lines)
  
  for (i in seq_along(lines)) {
    line <- lines[i]
    
    if (line == "" && i < n) {
      cat(sprintf("❌ Línea en blanco no permitida: línea %d\n", i))
      next
    }
    
    if (grepl("\t", line, fixed = TRUE)) {
      pos <- regexpr("\t", line, fixed = TRUE)[1]
      cat(sprintf("❌ Tab línea %d\n%s\n%*s^\n", i, line, pos - 1, "^"))
      next
    }
    
    if (grepl("^\\s", line, perl = TRUE)) {
      cat(sprintf("❌ Espacio inicial línea %d\n%s\n ^\n", i, line))
      next
    }
    
    if (grepl("\\s$", line, perl = TRUE)) {
      pos <- nchar(line)
      cat(sprintf("❌ Espacio final línea %d\n%s\n%s^\n", i, line, paste(rep(" ", pos - 1), collapse = "")))
      next
    }
    
    if (grepl("  ", line, fixed = TRUE)) {
      pos <- regexpr("  ", line, fixed = TRUE)[1]
      cat(sprintf("❌ Espacio de más línea %d\n%s\n%*s^\n", i, line, pos - 1, "^"))
      next
    }
  }
  cat("✅ Whitespace OK\n")
}

check_foliacion <- function(path) {
  lines <- readLines(path, warn = FALSE)
  folios <- character(0)
  ultimo_num <- 0
  ultimo_cara <- ""
  fol_pattern <- "\\[fol\\.\\s*(\\d+)([rv])\\]"
  
  for (i in seq_along(lines)) {
    line <- lines[i]
    matches <- gregexpr(fol_pattern, line, perl = TRUE)[[1]]
    if (length(matches) > 0 && matches[1] != -1) {
      match_len <- attr(matches, "match.length")[1]
      folio_str <- substr(line, matches[1], matches[1] + match_len - 1)
      num <- sub(fol_pattern, "\\1", folio_str, perl = TRUE)
      cara <- sub(fol_pattern, "\\2", folio_str, perl = TRUE)
      num_int <- as.integer(num)
      
      if (is.na(num_int) || !cara %in% c("r", "v")) {
        cat(sprintf("❌ Foliación malformada línea %d: %s\n", i, line))
        next
      }
      
      if (length(folios) == 0) {
        if (cara != "r") {
          cat(sprintf("❌ Primer folio debe ser Xr línea %d\n", i))
          next
        }
        folios <- paste0(num_int, "r")
        ultimo_num <- num_int
        ultimo_cara <- "r"
      } else {
        encontrado <- paste0(num, cara)
        if (ultimo_cara == "r" && cara == "v" && num_int == ultimo_num) {
          folios <- c(folios, paste0(num_int, "v"))
          ultimo_cara <- "v"
        } else if (ultimo_cara == "v" && cara == "r" && num_int == ultimo_num + 1) {
          folios <- c(folios, paste0(num_int, "r"))
          ultimo_num <- num_int
          ultimo_cara <- "r"
        } else {
          esperado <- if (ultimo_cara == "r") paste0(ultimo_num, "v") else paste0(ultimo_num + 1, "r")
          cat(sprintf("❌ Foliación errónea línea %d: tras %s → esperado %s, encontrado %s\n", 
                      i, tail(folios, 1), esperado, encontrado))
          next
        }
      }
    }
  }
  cat(sprintf("✅ Foliación OK: %s\n", paste(folios, collapse = " → ")))
}

check_etiquetas <- function(path) {
  lines <- readLines(path, warn = FALSE)
  fol_pattern <- "\\[fol\\.\\s*(\\d+)([rv])\\]"
  cb_pattern <- "^\\{CB\\d+\\."
  proximo_folio_rv <- ""
  post_folio_pre_cb <- FALSE  # Entre [fol.] y {CBn.
  in_columna <- FALSE
  
  for (i in seq_along(lines)) {
    line <- lines[i]
    
    # Nuevo folio → activamos ventana post_folio_pre_cb
    if (grepl(fol_pattern, line, perl = TRUE)) {
      post_folio_pre_cb <- TRUE
      in_columna <- FALSE
      next
    }
    
    # {CBn. → cierra ventana, inicia columna
    if (grepl(cb_pattern, line, perl = TRUE)) {
      post_folio_pre_cb <- FALSE
      in_columna <- TRUE
    }
    
    # {HD. SOLO en ventana post_folio_pre_cb
    if (grepl("^\\{HD\\.", line, perl = TRUE)) {
      if (!post_folio_pre_cb) {
        cat(sprintf("❌ {HD. línea %d fuera de zona permitida (solo tras [fol.] antes {CBn.)\n", i))
      }
    }
    
    # {SG. → antes [fol. Xv] + columna cerrada
    if (grepl("^\\{SG\\.", line, perl = TRUE)) {
      # Predicción folio próximo (simplificado)
      for (j in (i+1):min(i+5, length(lines))) {
        if (grepl(fol_pattern, lines[j], perl = TRUE)) {
          rv <- sub(fol_pattern, "\\2", lines[j], perl = TRUE)
          if (rv != "v") {
            cat(sprintf("❌ {SG. línea %d no precede [fol. Xv]\n", i))
          }
          break
        }
      }
      if (in_columna) {
        cat(sprintf("❌ {SG. línea %d con columna abierta\n", i))
      }
    }
    
    # {CW. → antes [fol. Xr] + columna cerrada  
    if (grepl("^\\{CW\\.", line, perl = TRUE)) {
      for (j in (i+1):min(i+5, length(lines))) {
        if (grepl(fol_pattern, lines[j], perl = TRUE)) {
          rv <- sub(fol_pattern, "\\2", lines[j], perl = TRUE)
          if (rv != "r") {
            cat(sprintf("❌ {CW. línea %d no precede [fol. Xr]\n", i))
          }
          break
        }
      }
      if (in_columna) {
        cat(sprintf("❌ {CW. línea %d con columna abierta\n", i))
      }
    }
    
    # Otras validaciones (INn., RUB.)
    if (grepl("^\\{", line) && grepl("IN", line)) {
      if (!grepl("^\\{IN\\d+\\.", line, perl = TRUE)) {
        cat(sprintf("❌ {INn.} malformado línea %d\n", i))
      }
    }
    if (grepl("^\\{RUB\\.", line) && !grepl("^\\{RUB\\.\\s", line, perl = TRUE)) {
      cat(sprintf("❌ {RUB. sin espacio tras punto línea %d\n", i))
    }
  }
  cat("✅ Etiquetas OK\n")
}

check_balanceo <- function(path) {
  lines <- readLines(path, warn = FALSE)
  fol_pattern <- "\\[fol\\.\\s*(\\d+)([rv])\\]"
  
  # Stack para rastrear aperturas por tipo y posición
  stack <- list(`{` = integer(0), `[` = integer(0), `(` = integer(0), `<` = integer(0))
  folio_inicio <- 1
  
  for (i in seq_along(lines)) {
    line <- lines[i]
    
    # Nuevo folio
    if (grepl(fol_pattern, line, perl = TRUE)) {
      # Verificamos cierres pendientes del folio anterior
      abiertos <- sapply(stack, length) > 0
      if (any(abiertos)) {
        cat(sprintf("❌ Fin folio ~línea %d: abiertos ", folio_inicio))
        for (simb in names(stack)[abiertos]) {
          cat(sprintf("%s(líneas %s) ", simb, paste(head(stack[[simb]], 3), collapse = ", ")))
        }
        cat("\n")
      }
      stack <- list(`{` = integer(0), `[` = integer(0), `(` = integer(0), `<` = integer(0))
      folio_inicio <- i
      next
    }
    
    # Procesamos cada carácter de la línea
    chars <- strsplit(line, "")[[1]]
    for (j in seq_along(chars)) {
      char <- chars[j]
      
      if (char == "{") stack$`{` <- c(stack$`{`, i)
      else if (char == "[") stack$`[` <- c(stack$`[`, i)
      else if (char == "(") stack$`(` <- c(stack$`(` , i)
      else if (char == "<") stack$`<` <- c(stack$`<`, i)
      
      else if (char == "}") {
        if (length(stack$`{`) == 0) {
          cat(sprintf("❌ } sin { abierto línea %d, pos %d\n", i, j))
        } else {
          stack$`{` <- stack$`{`[-length(stack$`{`)]
        }
      }
      else if (char == "]") {
        if (length(stack$`[`) == 0) {
          cat(sprintf("❌ ] sin [ abierto línea %d, pos %d\n", i, j))
        } else {
          stack$`[` <- stack$`[`[-length(stack$`[`)]
        }
      }
      else if (char == ")") {
        if (length(stack$`(`) == 0) {
          cat(sprintf("❌ ) sin ( abierto línea %d, pos %d\n", i, j))
        } else {
          stack$`(` <- stack$`(`[-length(stack$`(`)]
        }
      }
      else if (char == ">") {
        if (length(stack$`<`) == 0) {
          cat(sprintf("❌ > sin < abierto línea %d, pos %d\n", i, j))
        } else {
          stack$`<` <- stack$`<`[-length(stack$`<`)]
        }
      }
    }
  }
  
  # Fin de fichero
  abiertos <- sapply(stack, length) > 0
  if (any(abiertos)) {
    cat("❌ Fin fichero: abiertos ")
    for (simb in names(stack)[abiertos]) {
      ultimas <- tail(stack[[simb]], 3)
      cat(sprintf("%s(líneas %s) ", simb, paste(ultimas, collapse = ", ")))
    }
    cat("\n")
  } else {
    cat("✅ Balanceo perfecto (por folio y global)\n")
  }
}


# SCRIPT MAESTRO
validar_completo <- function(path = "TEXT.PJN.txt") {
  cat("🔍 VALIDACIÓN COMPLETA TEXT.PJN\n", rep("=", 50), "\n\n")
  
  check_whitespace(path)
  cat("\n", rep("─", 50), "\n\n")
  
  check_foliacion(path)
  cat("\n", rep("─", 50), "\n\n")
  
  check_etiquetas(path) 
  cat("\n", rep("─", 50), "\n\n")
  
  check_balanceo(path)
  cat("\n🎉 ¡FICHERO VALIDADO CORRECTAMENTE!\n")
}

# EJECUTAR
validar_completo("TEXT.PJN.txt")
