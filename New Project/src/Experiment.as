package
{
import flash.events.MouseEvent;
import mx.events.ItemClickEvent;
import mx.skins.halo.DateChooserYearArrowSkin;
import flash.geom.Point;
import slabLibrary.PIEslab;
import pie.graphicsLibrary.*;
import pie.uiElements.*;
import slabLibrary.PIEbulb;

public class Experiment
{
/* TestProject Framework Handle */
private var pieHandle:PIE;

/**
 *
 * This section contains Physics Parameters
 *
 */
private var PIEaspectRatio:Number;
private var worldOriginX:Number;
private var worldOriginY:Number;
private var worldWidth:Number;
private var worldHeight:Number;

/**
 *
 * This section contains Drawing Objects
 *
 */
/* Display Parameters */
private var displayBColor:uint;
private var displayFColor:uint;
private var UIpanelBColor:uint;
private var UIpanelFColor:uint;
private var slabColor:uint;
private var bulbColor:uint;
/* Bob Parameters */
/* Layout Variables */

/**
 *
 * This section contains current state variables
 *
 */
/* Position Variables */
private var mainSlabX:Number;
private var mainSlabY:Number;
private var mainBulbX:Number;
private var mainBulbY:Number;
private var mainSlabH:Number;
private var mainSlabW:Number;
private var mainSlabT:Number;
private var mainBulbR:Number;
private var dSequence:uint;
private var holeRadius:Number;
private var illustration:Number;
private var currentTime:Number;
/**
 *
 * This section stores the handles of Drawing and UI Objects
 *
 */
private var mainSlab:PIEslab;
private var mainBulb:PIEbulb;
private var hole:PIEarc;
private var nextButton : PIEbutton;
private var startButton : PIEbutton;
/**
 *
 * This function is called by the PIE framework at the beginning of the experiment
 * The PIE developer has to code the following steps in this section of his code
 *     define a whole range of global (accessible throughout the file) variables to capture initial state
 *     - the basic set of physics variables (velocity, position etc.) of the moving and non moving object
 *     - the basic set of drawing variables (dimension etc.) of the (in particualr) non moving objects
 *
 *     define a whole range of global variables to capture current state (variables which change with time)
 *
 *     define a whole range of global variables to store the handles (integer numbers) of all the objects
 *
 *     obtain the dimensions of  drawinng area from PIE framework and store in global variable
 *
 *     call a PIE framework function to  set the dimensions of the drawing area, right panel and bottom panel
 *
 *     define the position of all the global (static) variables
 *
 *     call PIE framework to create all experiment + UI objects and store returned integers in appropriate handles
 *
 *     set the values of the current state variables to initial values
 *
 * At this stage, we have defined how the initial experiment will appear to the user
 * Our experiment file code now has to  wait for the PIE framework to call other functions depending on user action
 *
 */
public function Experiment(pie:PIE)
{
    /* Store handle of PIE Framework */
    pieHandle = pie;
	illustration = 0;
    /* Call a PIE framework function to set the dimensions of the drawing area, right panel and bottom panel */
    /* We will reserve 100% width and 100%height for the drawing area */
    pieHandle.PIEsetDrawingArea(1.0,1.0);

    /* Set the foreground ande background colours for the three areas */
    /* (Different panels are provided and you can set individually as well) */
    displayBColor = 0X040404;
    displayFColor = 0XAA0000;
    UIpanelBColor = 0XFFFFFF;
    UIpanelFColor = 0XCCCCCC;
    pieHandle.PIEsetDisplayColors(displayBColor, displayFColor);
    pieHandle.PIEsetUIpanelColors(UIpanelBColor, UIpanelFColor);
    /* Set the Experiment Details */
    pieHandle.PIEcreateResetButton();
	pieHandle.ResetControl.addClickListener(this.resetSimulation);
	pieHandle.PIEcreatePauseButton();
	pieHandle.PIEcreateSpeedButtons();
   // pieHandle.showDeveloperName("Roshan Piyush");
    /* Initialise World Origin and Boundaries */
    this.resetWorld();

    /* define the position of all the global (static) variables */
    /* Code in a single Function (recommended) for reuse */
    this.resetExperiment();

    /* The PIE framework provides default pause/play/reset buttons in the bottom panel */
    /* If you need any more experiment control button such as next frame etc., call the function code here */
    /* Create Experiment Objects */
    createExperimentObjects();
}

/**
 *
 * This function is called by the PIE framework to reset the experiment to default values
 * It defines the values of all the global (static) variables
 *
 */
public function resetExperiment():void
{
	
	
    /* Initialise Physics Parameters */
	switch(illustration) {
	case 0: 
		pieHandle.showExperimentName("\t\t\t\t\t\t\t\t\t");
		pieHandle.showExperimentName("Heating Effect of Bulb on Wax");
		mainSlabX = 0.0;
		mainSlabY = 0.0;
		mainBulbX = 0.0;
		mainBulbY = -23.0;
		mainSlabH = 30.0;
		mainSlabW = 5.0;
		mainBulbR = 7.0;
		mainSlabT = 2.0;
		break;

	case 1: 
		pieHandle.showExperimentName("\t\t\t\t\t\t\t\t\t");
		pieHandle.showExperimentName("Heating Effect of Bulb on Ice Slab");
		mainSlabX = 0.0;
		mainSlabY = 0.0;
		mainBulbX = 0.0;
		holeRadius = 0.0;
		mainBulbY = -15.0;
		mainSlabH = 15.0;
		mainSlabW = 30.0;
		mainBulbR = 7.0;
		mainSlabT = 2.0;
		currentTime = mainBulbR;
		break;
	}
}



/*
 * This function resets the world boundaries and adjusts display to match the world boundaries
 */
public function resetWorld():void
{
    /* get the PIE drawing area aspect ratio (width/height) to model the dimensions of our experiment area */
    PIEaspectRatio = pieHandle.PIEgetDrawingAspectRatio();

    /* Initialise World Origin and Boundaries */
    worldWidth   = 150;                            /* 250 centimeters Width */
    worldHeight  = worldWidth / PIEaspectRatio;   /* match world aspect ratio to PIE aspect ratio */
    worldOriginX = (-worldWidth/2);               /* Origin at center */
    worldOriginY = (-worldHeight/2);
    pieHandle.PIEsetApplicationBoundaries(worldOriginX, worldOriginY, worldWidth, worldHeight);
	pieHandle.showDeveloperName(worldHeight.toString());
}

/**
 *
 * This function is called by the PIE framework after every system Timer Iterrupt
 *
 */
public function nextFrame():void
{
	var xSlab : Number;
	var ySlab : Number;
	var xBulb : Number;
	var yBulb : Number;
	var distance : Number;
	var cons : Number;
	switch(illustration){
	case 0:
		meltWax();
		break;
	case 1:
		meltSlab();
		break;
	}
}

/**
 *
 * This function is called to create the experiment objects
 * It calls the appropriate constructors to create drawing objects
 * It also sets callback variables to point to callback code
 *
 */
private function createExperimentObjects():void
{
	var centerLine:PIEline;

    /* Set Default Colors */
    slabColor    = 0xFFFFFA;
	bulbColor    = 0xFF2B06;
	
	nextButton = new PIEbutton(pieHandle, "NEXT");
	nextButton.addClickListener(nextExperiment);
	nextButton.setVisible(true);
	nextButton.setActualSize(100, 40);
	pieHandle.addUIpanelChild(nextButton);

    /* Create Slab */
	mainSlab = new PIEslab(pieHandle, mainSlabX, mainSlabY, mainSlabH, mainSlabW, mainSlabT, slabColor);
	mainSlab.changeFill(slabColor,0.5);

    pieHandle.addDisplayChild(mainSlab);
    mainSlab.changeFill(slabColor,0.5);
    pieHandle.addDisplayChild(mainSlab);
	
	hole = new PIEarc(pieHandle, mainBulbX, mainBulbY, mainBulbX-mainBulbR, mainBulbY, Math.PI, displayBColor);
	hole.changeFillColor(displayBColor);
	pieHandle.addDisplayChild(hole);
	
	mainBulb = new PIEbulb(pieHandle, mainBulbX, mainBulbY, mainBulbR, bulbColor);
    mainBulb.changeFill(slabColor,0.5);
	mainBulb.bulbOff();
    pieHandle.addDisplayChild(mainBulb);
    mainBulb.changeFill(bulbColor,0.5);
    pieHandle.addDisplayChild(mainBulb);

	
}



public function handleSlabGrab(clickX:Number, clickY:Number):void
{
}


public function handleSlabDrag(newX:Number, newY:Number, displacementX:Number, displacementY:Number):void
{
	
    this.mainSlabX = newX;
	this.mainSlabY = newY;
}

public function handleSlabDrop(newX:Number, newY:Number, displacementX:Number, displacementY:Number):void
{
    this.mainSlabX = newX;
	this.mainSlabY = newY;
}


public function handleStretchBegin(clickX:Number, clickY:Number):void
{
}


public function handleStretchEnd(newX:Number, newY:Number, displacementX:Number, displacementY:Number):void
{
}

private function meltWax():void {
	var xSlab : Number;
	var ySlab : Number;
	var xBulb : Number;
	var yBulb : Number;
	var distance : Number;
	var dt:Number;
	var cons : Number;
	xSlab = mainSlab.getAnchorX();
	ySlab = mainSlab.getAnchorY();
	xBulb = mainBulb.getAnchorX();
	yBulb = mainBulb.getAnchorY();
	dt = pieHandle.PIEgetDelay()/50;
	distance = Math.sqrt(Math.pow(xSlab - xBulb, 2) + Math.pow(ySlab - yBulb, 2)) - mainBulb.getRadius() - mainSlab.getHeight() / 2;
	if (mainSlab.getHeight() > 0 && distance > 0 && mainBulb.getBulbStatus()) {
		distance = Math.sqrt(Math.pow(xSlab - xBulb, 2) + Math.pow(ySlab - yBulb, 2)) - mainBulb.getRadius() - mainSlab.getHeight() / 2;
		distance = distance * 5;
		mainSlab.changeHeight(mainSlab.getHeight() - dt / distance);
		mainSlab.changeLocation(xSlab, ySlab + 0.5*dt / distance);
	}
}

private function meltSlab():void {
	var xSlab : Number;
	var ySlab : Number;
	var xBulb : Number;
	var yBulb : Number;
	var distance : Number;
	var holeRadius : Number;
	var dt:Number;
	xSlab = mainSlab.getAnchorX();
	ySlab = mainSlab.getAnchorY();
	xBulb = mainBulb.getAnchorX();
	yBulb = mainBulb.getAnchorY();
	distance = Math.sqrt(Math.pow(xSlab - xBulb, 2) + Math.pow(ySlab - yBulb, 2)) - mainBulb.getRadius() - mainSlab.getHeight() / 2;
	dt = pieHandle.PIEgetDelay()/100;
    currentTime = currentTime + dt/(currentTime*Math.sqrt(distance));
	if (mainSlab.getHeight() > 0 && mainBulb.getBulbStatus()) {
		hole.changeSize(currentTime);
		
	}
}


public function resetSimulation():void {
	
	this.resetExperiment();
	mainSlab.changeLocation(mainSlabX, mainSlabY);
	mainSlab.changeHeight(mainSlabH);
	mainSlab.changeWidth(mainSlabW);
	mainBulb.changeLocation(mainBulbX, mainBulbY);
	pieHandle.PIEresetTimer();
	mainBulb.bulbOff();
	switch(illustration) {
		case 0:
			hole.setPIEinvisible();
			break;
		case 1:
			hole.changeLocation(mainBulbX, mainBulbY);
			hole.setPIEvisible();
			hole.changeSize(0);
			hole.enablePIEtransform();
			break;
	}
	
}

public function nextExperiment():void {
	illustration = (illustration + 1) % 2;
	this.resetExperiment();
	mainSlab.changeLocation(mainSlabX, mainSlabY);
	mainSlab.changeHeight(mainSlabH);
	mainSlab.changeWidth(mainSlabW);
	mainBulb.changeLocation(mainBulbX, mainBulbY);
	pieHandle.PIEresetTimer();
	mainBulb.bulbOff();
	switch(illustration) {
		case 0:
			hole.setPIEinvisible();
			break;
		case 1:
			hole.changeLocation(mainBulbX, mainBulbY);
			hole.setPIEvisible();
			hole.changeSize(0);
			hole.enablePIEtransform();
			break;
	}
	
}


}   /* End of Class experiment */


}


