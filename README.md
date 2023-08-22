# WHURS-SP
Homework of Course Satellite Photogrammetry in Wuhan University —— RPC Model


The project primarily accomplished a terrain-independent RFM (Rational Function Model) control scheme by programming to establish an RPC (Rational Polynomial Coefficient) model. Both the forward and inverse RPC models were established.

Taking the forward RPC model as an example:

1.Utilizing data from satellite-borne GPS, satellite orbit ephemeris, satellite attitude determination, and other sources, the project computed the planimetric positions of image points on different elevation surfaces according to a rigorous geometric model. This process generated a dataset of evenly distributed ground control points in the form of a grid (virtual ground control point coordinates).

2.The project solved the RPC parameters and calculated the ground control point coordinates.

3.Using DEM (Digital Elevation Model) data, check points were generated in the ground space to validate the accuracy of the obtained RPC coefficients.

## NAD.txt
Placemen​t Matrix Information of the Camera on the Satellite. 

It can be constructed from three angular elements: pitch, roll, and yaw, 
forming an orthogonal matrix from the camera coordinate system (or sensor coordinate system) to the satellite body coordinate system.

## DX_ZY3_NAD_imagingTime.txt
Time Labels for Each Row of Image Scene

## gps.txt
WGS84 Coordinates of Discrete-Time Satellite Center of Mass

## att.txt
Attitude of the Satellite at Discrete Time Points

## j2w_r.txt
Rotation matrix data from J2000 to WGS84 coordinate system can be obtained from the website https://hpiers.obspm.fr/eop-pc/index.php?index=matrice_php&lang=en.

## dem.tif
Elevation information from GDEMV3 data can be obtained from the link: https://www.gscloud.cn/sources/accessdata/aeab8000652a45b38afbb7ff023ddabb?pid=302
