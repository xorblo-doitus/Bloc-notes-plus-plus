soffice --headless --convert-to "csv:Text - txt - csv (StarCalc):44,34,UTF8,1," --outdir src/assets/translations raw_assets/translations/*.ods
python tasks/asset_exporting/translations/clean_translations.py