package  
{
/**
 * 
 * For every image to be used, the following syntax needs to be followed
 * 
 * [Embed(source = 'absolute or relative path of the file')]
 * public static const _name_to_be_used:Class; 
 * 
 * For cases there is only one or two images, 
 * this class can also be omitted and the above two lines can be directly 
 * used in the Experiment.as. 
 * 
 */
public class PIEimageLocation
{		
[Embed(source = 'images/earth.png')]
public static const earthImgPtr:Class; 

[Embed(source = 'images/mars.png')]
public static const marsImgPtr:Class; 

[Embed(source = 'images/jupiter.png')]
public static const jupiterImgPtr:Class; 

[Embed(source = 'images/saturn.png')]
public static const saturnImgPtr:Class; 

[Embed(source = 'images/bar_magnet.jpg')]
public static const magnetImgPtr:Class; 

} /* End of Image Class */

}