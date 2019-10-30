The following Matlab code implements an intra frame encoder for Point Cloud Geometry based on Dyadic Decomposition.

To execute the code, you need first to run the script "startup.m", which adds the files to the Matlab Path. 

The code makes use of two Matlab functions of the Lidar and Point Cloud Processing Toolbox, namely pcread() and
pcwrite(), to open and write the point cloud file format ply. 

Afterwards, there are 2 functions and 3 scripts that can be used:
 - The function 
    enc = encodePointCloudGeometry(inputFile, outputFile)
	takes two inputs, the input Ply file with the Point Cloud data to be encoded, and the output Binary file.
	It compress the input data to the output file, and returns an encoder object.
	
 - The function
    dec = decodePointCloudGeometry(inputFile, outputFile)
	takes two inputs, the binary input file and the output Ply file.
	It decodes the data, writing the ply file to the outputFile, and returns a decoder object.
	
 - The script script_testEncoderDecoder runs both the encoder and the decoder, and then it checks if the decoder
   was able to succesffuly decode the data (the compression is lossless). Note that the input of the script should be changed to reflect your system (i.e., the location of the files in your system).
   
 - The script scriptRunDecoder decodes all files in the dataset provided (i.e., all sequences in the Microsoft
   Upper Bodies Dataset and the 8i Full Bodies Dataset). Note that the input of the script should be changed to reflect your system (i.e., the location of the files in your system).
   
 - The script scriptRunEncoder encodes all files in the dataset. The JPEG Pleno dataset can be downloaded at:
     https://jpeg.org/plenodb/ . Note that the input of the script should be changed to reflect your system (i.e., the location of the files in your system).
     
  Eduardo Peixoto
  eduardopeixoto@ieee.org