**IMC tiffs to dataframes.ipynb** is a python notebook that takes your ImageJ generated mask file, your MCD2TIFF generated tiffs, and your panel .csv to measure total signal on a per-cell, per-channel basis. This data is then added to a long form or wide form dataframe. All files are assumed to be in the same folder.

For this code to work, the panel .csv name must match the name referenced. The name of the tiff files and their respective masks must match the format outlined in the notebook. read the comments carefully they indicate where code customisations are necessary.

IMC tiffs to "dataframes.ipynb" is the notebook to use with your own data, "importing to dataframes - Example output .ipynb" is populated with example outputs so you can see what to expect.
