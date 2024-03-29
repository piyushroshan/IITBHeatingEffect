﻿package
{
import flash.display.Sprite;
import flash.events.MouseEvent;
import mx.events.ItemClickEvent;
import mx.skins.halo.DateChooserYearArrowSkin;
import flash.geom.Point;
import pie.graphicsLibrary.*;
import pie.uiElements.*;

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
private var sprite:Sprite;
private var hole:PIEarc;
private var nextButton : PIEbutton;
private var startButton : PIEbutton;
private var mainSlab:PIErectangle;
private var middleDrag1:PIErectangle;
private var bulbDrag:PIEcircle;
private var plusWire:PIEroundedRectangle;
private var switchB:PIEline;
private var switchBlack:PIErectangle;
private var battery:PIEroundedRectangle;
private var plusBattery:PIEroundedRectangle;
private var bulbStatus:Boolean;
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
    pieHandle.PIEsetDrawingArea(0.8,1.0);

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
    pieHandle.showDeveloperName("Roshan Piyush");
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

/*
 * This function resets the world boundaries and adjusts display to match the world boundaries
 */
public function resetWorld():void
{
    /* get the PIE drawing area aspect ratio (width/height) to model the dimensions of our experiment area */
    PIEaspectRatio = pieHandle.PIEgetDrawingAspectRatio();
    /* Initialise World Origin and Boundaries */
    worldHeight   = 200.0;                            
    worldWidth  = worldHeight * PIEaspectRatio;   /* match world aspect ratio to PIE aspect ratio */
    worldOriginX = (-worldWidth/2);               /* Origin at center */
    worldOriginY = ( -worldHeight / 2);
	pieHandle.showDeveloperName(PIEaspectRatio.toString());
    pieHandle.PIEsetApplicationBoundaries(worldOriginX, worldOriginY, worldWidth, worldHeight);
}

/**
 *
 * This function is called by the PIE framework to reset the experiment to default values
 * It defines the values of all the global (static) variables
 *
 */
public function resetExperiment():void
{
	currentTime = mainBulbR;
	
    /* Initialise Physics Parameters */
	switch(illustration) {
	case 0: 
		pieHandle.showExperimentName("\t\t\t\t\t\t\t\t\t");
		pieHandle.showExperimentName("Heating Effect of Bulb on Ice Slab");

		mainBulbR = worldHeight /10;
		mainBulbX = 0;
		mainBulbY = -worldHeight / 8;
		
		mainSlabH = worldHeight / 4;
		mainSlabW = worldWidth / 4;
		
		mainSlabX = -mainSlabW/2;
		mainSlabY = 0;
		currentTime = mainBulbR;
		break;

	case 1: 
		pieHandle.showExperimentName("\t\t\t\t\t\t\t\t\t");
		pieHandle.showExperimentName("Heating Effect of Bulb on Wax");		
		mainBulbR = worldHeight /10;
		mainBulbX = 0;
		mainBulbY = -worldHeight / 8;
		
		mainSlabH = worldHeight / 3;
		mainSlabW = worldWidth / 20;
		
		mainSlabX = -mainSlabW/2;
		mainSlabY = 0;
		currentTime = mainBulbR;
		break;
	}
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
	var holeRadius : Number;
	var dt:Number;
	switch(illustration){
	case 0:
		xSlab = mainSlabX;
		ySlab = mainSlabY;
		xBulb = mainBulbX;
		yBulb = mainBulbY;
		distance = Math.sqrt(Math.pow(xSlab - xBulb, 2) + Math.pow(ySlab - yBulb, 2)) - mainBulbR;
		dt = pieHandle.PIEgetDelay();
		currentTime = currentTime + 0.01;
		if ( getBulbStatus()) {
			hole.changeSize(currentTime);
		}
		pieHandle.showDeveloperName(currentTime.toString());
		break;
	case 1:
		meltWax();
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
	mainSlab = new PIErectangle(pieHandle, mainSlabX, mainSlabY, (mainSlabW), (mainSlabH), displayFColor);
	mainSlab.setPIEvisible();
	mainSlab.changeBorder(1, 0x000000, 0.5); 
    pieHandle.addDisplayChild(mainSlab);
	
	hole = new PIEarc(pieHandle, mainBulbX, mainBulbY, mainBulbX+mainBulbR, mainBulbY, Math.PI, displayBColor);
	hole.changeFillColor(displayBColor);
	hole.setPIEvisible();
	pieHandle.addDisplayChild(hole);
	bulbStatus = false;
    plusWire = new PIEroundedRectangle(pieHandle, mainBulbX+5*mainBulbR/4, ( mainBulbY-mainBulbR), (2*mainBulbR), (2*mainBulbR), 0x000000);
	plusWire.changeBorder(2, 0x00FF00, 0.3);
	pieHandle.addDisplayChild(plusWire);
	battery = new PIEroundedRectangle(pieHandle, mainBulbX +2 * mainBulbR - 10, (mainBulbY-mainBulbR - 5), 20, 10, 0x0FF000);
	pieHandle.addDisplayChild(battery);
	plusBattery = new PIEroundedRectangle(pieHandle,mainBulbX +2 * mainBulbR + 10-3, (mainBulbY-mainBulbR-3), 6, 6, 0x0FF000);
	pieHandle.addDisplayChild(plusBattery);
	switchBlack = new PIErectangle(pieHandle,mainBulbX+5 * mainBulbR/2 , (mainBulbY+mainBulbR-7), 15, 14, 0x000000);
	switchBlack.addClickListener(toggleSwitch);
	pieHandle.addDisplayChild(switchBlack);
	switchB = new PIEline(pieHandle, mainBulbX+5 * mainBulbR / 2, (mainBulbY+mainBulbR + 1) , mainBulbX+5 * mainBulbR / 2 + 5, mainBulbY+mainBulbR - 10, 0xFFFFFF, 4, 0.5);
	switchB.addClickListener(toggleSwitch);
	switchB.setPIEvisible();
	pieHandle.addDisplayChild(switchB);
	middleDrag1 = new PIErectangle(pieHandle,mainBulbX+mainBulbR / 2 , ((mainBulbY -mainBulbR / 2)), (mainBulbR), (mainBulbR), 0xFF2BD6);
	middleDrag1.changeBorder(1, 0x000000, 0.5); 
    pieHandle.addDisplayChild(middleDrag1);
	bulbDrag = new PIEcircle(pieHandle, mainBulbX , mainBulbY, mainBulbR, displayFColor);
	bulbDrag.changeBorder(1, 0x000000, 0.5); 
    pieHandle.addDisplayChild(bulbDrag);
	
	
	
}


private function meltWax():void {
	var xSlab : Number;
	var ySlab : Number;
	var xBulb : Number;
	var yBulb : Number;
	var distance : Number;
	var dt:Number;
	var cons : Number;
	xSlab = mainSlabX;
	ySlab = mainSlabY;
	xBulb = mainBulbX;
	yBulb = mainBulbY;
	dt = pieHandle.PIEgetDelay();
	distance = Math.sqrt(Math.pow(xSlab - xBulb, 2) + Math.pow(ySlab - yBulb, 2)) - mainBulbR - mainSlabH / 2;
	if (mainSlabH > 0 && getBulbStatus()) {
		distance = distance * 50;
		mainSlab.changeSize(mainSlabW,mainSlabH-dt/distance);
		mainSlab.changeLocation(xSlab, ySlab);
	}
	pieHandle.showDeveloperName(mainSlabH.toString());
}

private function meltSlab():void {
	var xSlab : Number;
	var ySlab : Number;
	var xBulb : Number;
	var yBulb : Number;
	var distance : Number;
	var holeRadius : Number;
	var dt:Number;
	xSlab = mainSlabX;
	ySlab = mainSlabY;
	xBulb = mainBulbX;
	yBulb = mainBulbY;
	distance = Math.sqrt(Math.pow(xSlab - xBulb, 2) + Math.pow(ySlab - yBulb, 2)) - mainBulbR;
	dt = pieHandle.PIEgetDelay();
    currentTime = currentTime + dt/(currentTime*Math.sqrt(distance));
	if ( getBulbStatus()) {
		hole.changeSize(currentTime);
	}
	pieHandle.showDeveloperName(currentTime.toString());
}


public function resetSimulation():void {
	
	this.resetExperiment();
	mainSlab.changeLocation(mainSlabX, mainSlabY);
	mainSlab.changeSize(mainSlabW, mainSlabH);
	pieHandle.PIEresetTimer();
	bulbOff();
	switch(illustration) {
		case 0:
			hole.setPIEinvisible();
			break;
		case 1:
			hole.setPIEvisible();
			hole.changeSize(mainBulbR);
			break;
	}
	
}

public function nextExperiment():void {
	illustration = (illustration + 1) % 2;
	this.resetExperiment();
	mainSlab.changeLocation(mainSlabX, mainSlabY);
	mainSlab.changeSize(mainSlabW, mainSlabH);
	pieHandle.PIEresetTimer();
	bulbOff();
	switch(illustration) {
		case 0:
			hole.setPIEvisible();
			hole.changeSize(mainBulbR);
			break;
		case 1:
			hole.setPIEinvisible();
			break;
	}
}


public function toggleSwitch():Boolean
{
	if (bulbStatus)
	{
		pieHandle.PIEpauseTimer();
		bulbStatus = false;
		bulbDrag.changeFillColor(0xFF2B06);
		switchB.changeLine(mainBulbX+5 * mainBulbR / 2, mainBulbY+mainBulbR + 1 , mainBulbX+5 * this.mainBulbR / 2 + 5, mainBulbY + this.mainBulbR - 10);
		return bulbStatus;
	}else
	{
		pieHandle.PIEresumeTimer();
		bulbStatus = true;
		bulbDrag.changeFillColor(0xFFFFFF);
		switchB.changeLine(mainBulbX+5 * this.mainBulbR / 2,mainBulbY+ (this.mainBulbR) , mainBulbX+ 5 * this.mainBulbR / 2 + 15, mainBulbY+ this.mainBulbR);
		return bulbStatus;
	}
}

public function bulbOff():Boolean {
	if (bulbStatus)
	{
		pieHandle.PIEpauseTimer();
		bulbStatus = false;
		bulbDrag.changeFillColor(0xFF2B06);
		switchB.changeLine(mainBulbX+5 * this.mainBulbR / 2, mainBulbY+(this.mainBulbR + 1) ,mainBulbX +5 * this.mainBulbR / 2 + 5,mainBulbY+ this.mainBulbR - 10);
	}
	return bulbStatus;
}

public function bulbOn():Boolean {
	if (!bulbStatus)
	{
		pieHandle.PIEresumeTimer();
		bulbStatus = true;
		bulbDrag.changeFillColor(0xFFFFFF);
		switchB.changeLine(mainBulbX+5 * mainBulbR / 2, (mainBulbY+mainBulbR + 1) , mainBulbX+5 * mainBulbR / 2 + 5, mainBulbY+mainBulbR - 10);
	}
	return bulbStatus;
}

public function getBulbStatus():Boolean {
	return bulbStatus;
}





}   /* End of Class experiment */


}


