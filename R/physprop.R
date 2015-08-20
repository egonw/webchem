#' Query SRC PHYSPROP Database
#'
#' Query SRCs PHYSPROP Database. The PHYSPROP database contains chemical structures,
#' names and physical properties for over 41,000 chemicals.
#' Physical properties collected from a wide variety of sources include experimental,
#' extrapolated and estimated values. For more information
#' see \url{http://www.srcinc.com/what-we-do/environmental/scientific-databases.html#physprop}.
#'
#' @import XML RCurl
#'
#' @param cas character; A CAS number to query.
#' @param verbose logical; print message during processing to console?
#'
#' @return A list of 4 entries: cas (CAS-Number), cname (Chemical Name),
#' mw (Molecular weigth) and prop (Properties).
#' prop is a data.frame, with variables, value, unit, temp, type (see note) and ref (see note).
#'
#' @note Abbreviations in the 'Type' field: EXP = Experimental Data,
#' EST = Estimated Data, EXT = Extrapolated Data. Extrapolated data is based
#' upon experimental measurement outside the temperature range of the reported value.
#' References below are abbreviated citations ...
#' the full reference citations are NOT available here.
#' References for Estimated data generally refer to the method used to make the estimate ...
#' most estimates were made using SRC software.
#'
#' @author Eduard Szoecs, \email{eduardszoecs@@gmail.com}
#' @export
#' @examples
#' \dontrun{
#' physprop('50-00-0')
#' lapply(c('50-00-0', '79622-59-6', 'xxxxx'), physprop)
#' }

physprop <- function(cas, verbose = TRUE){
  # cas = '50-00-0'
  # cas <- '79622-59-6'
  query <- gsub('-', '', cas)
  baseurl <- 'http://esc.syrres.com/fatepointer/webprop.asp?CAS='
  qurl <- paste0(baseurl, query)
  if (verbose)
    message('Querying ', qurl)
  ttt <- htmlParse(getURL(qurl, .encoding = 'UTF-8'), useInternalNodes = TRUE,
                   encoding="UTF-8")
  Sys.sleep(0.1)

  if (grepl('No records', xpathSApply(ttt, '//p', xmlValue)[3])) {
    message('Not found! Returning NA.\n')
    return(NA)
  }

  variables <- xpathSApply(ttt, '//ul/following-sibling::text()[1]', xmlValue)
  variables <- gsub(':', '', variables)

  prop <- do.call(rbind, xpathApply(ttt, '//ul[@class!="ph"]', function(node){
    value_var <- xpathSApply(node, './li[starts-with(text(),"Value")]', xmlValue)
    value_var <- gsub('Value.:.(.*)', '\\1', value_var)
    value <- gsub('^(\\d*\\.?\\d*).*', '\\1', value_var)
    unit <- gsub('^\\d*\\.?\\d*.(.*)', '\\1', value_var)
    temp <- xpathSApply(node, './li[starts-with(text(),"Temp")]', xmlValue)
    if (length(temp) == 0) {
      temp <- NA
    } else {
      temp <- gsub('Temp.*:.(.*)', '\\1', temp)
    }
    type <- xpathSApply(node, './li[starts-with(text(),"Type")]', xmlValue)
    if (length(type) == 0) {
      type <- NA
    } else {
      type <- gsub('Type.*:.(.*)', '\\1', type)
    }
    ref <- xpathSApply(node, './li[starts-with(text(),"Ref")]', xmlValue)
    if (length(ref) == 0) {
      ref <- NA
    } else {
      ref <- gsub('Ref.*:.(.*)', '\\1', ref)
    }
    out <- data.frame(value, unit, temp, type, ref, stringsAsFactors = FALSE)
    return(out)
  }))
  prop$variable <- variables
  prop <- prop[, c("variable", "value", "unit", "temp", "type", "ref")]

  cas <- xpathApply(ttt, '//ul[@class="ph"]/li[starts-with(text(),"CAS")]',xmlValue)[[1]]
  cas <- sub(".*:.", "", cas)
  cas <- sub("^[0]+", "", cas)

  cname <- xpathApply(ttt, '//ul[@class="ph"]/li[starts-with(text(),"Chem")]',xmlValue)[[1]]
  cname <- sub(".*:.", "", cname)

  mw <- xpathApply(ttt, "//ul[@class='ph']/li[4]",xmlValue)[[1]]
  mw <- sub(".*:.", "", mw)

  out <- list(cas = cas, cname = cname, mw = mw, prop = prop)
  return(out)
}

