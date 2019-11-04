# Point Cloud Geometry Coder

The following Matlab code implements an intra frame encoder for Point Cloud Geometry based on Dyadic Decomposition.

# Usage

To execute the code, you need first to run the script `startup`, which adds the project to your Matlab Path.

Afterwards, there are 2 functions and 3 scripts that can be used:
 - The function
    `enc = encodePointCloudGeometry(inputFile, outputFile)`
	takes two inputs, the input Ply file with the Point Cloud data to be encoded, and the output Binary file.
	It compress the input data to the output file, and returns an encoder object.

 - The function
    `dec = decodePointCloudGeometry(inputFile, outputFile)`
	takes two inputs, the binary input file and the output Ply file.
	It decodes the data, writing the ply file to the outputFile, and returns a decoder object.

 - The script `script_testEncoderDecoder` runs both the encoder and the decoder, and then it checks if the decoder
   was able to succesffuly decode the data (the compression is lossless). Note that the input of the script should be changed to reflect your system (i.e., the location of the files in your system).

 - The script `scriptRunDecoder` decodes all files in the dataset provided (i.e., all sequences in the Microsoft
   Upper Bodies Dataset and the 8i Full Bodies Dataset). Note that the input of the script should be changed to reflect your system (i.e., the location of the files in your system).

 - The script `scriptRunEncoder` encodes all files in the dataset. The JPEG Pleno dataset can be downloaded at:
     https://jpeg.org/plenodb/ . Note that the input of the script should be changed to reflect your system (i.e., the location of the files in your system).

# Contact Person

[Eduardo Peixoto](eduardopeixoto@ieee.org)

# Credits

[Philipp Gira](https://scholar.google.at/citations?user=ANBHN2AAAAAJ): [Point cloud tools for Matlab](https://www.geo.tuwien.ac.at/downloads/pg/pctools/pctools.html).
