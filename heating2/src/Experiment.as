package
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
private var displayBcolor:uint;
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
private var mainCircuitX:Number;
private var mainCircuitY:Number;
private var mainCircuitH:Number;
private var mainCircuitW:Number;
private var currentTime:Number;
private var steelT:Number;
private var steelL:Number;
/**
 *
 * This section stores the handles of Drawing and UI Objects
 *
 */

private var resetButton : PIEbutton;
private var circuit:PIErectangle;
private var switchB:PIEline;
private var switchBlack:PIErectangle;
private var battery1:PIEroundedRectangle;
private var plusBattery1:PIEroundedRectangle;
private var battery2:PIEroundedRectangle;
private var plusBattery2:PIEroundedRectangle;
private var battery3:PIEroundedRectangle;
private var plusBattery3:PIEroundedRectangle;
private var circuitStatus:Boolean;
private var resistorBlack:PIErectangle;
private var resistor:PIErectangle;
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
    /* Call a PIE framework function to set the dimensions of the drawing area, right panel and bottom panel */
    /* We will reserve 100% width and 100%height for the drawing area */
    pieHandle.PIEsetDrawingArea(1.0,1.0);

    /* Set the foreground ande background colours for the three areas */
    /* (Different panels are provided and you can set individually as well) */
    displayBcolor = 0X040404;
    displayFColor = 0XAA0000;
    UIpanelBColor = 0XFFFFFF;
    UIpanelFColor = 0XCCCCCC;
    pieHandle.PIEsetDisplayColors(displayBcolor, displayFColor);
    pieHandle.PIEsetUIpanelColors(UIpanelBColor, UIpanelFColor);
    /* Set the Experiment Details */
    pieHandle.PIEcreateResetButton();
	pieHandle.ResetControl.addClickListener(this.resetExperiment);
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
	
		pieHandle.showExperimentName("\t\t\t\t\t\t\t\t\t");
		pieHandle.showExperimentName("Heating Effect of Current on Steel-wool");
		
		mainCircuitH = worldHeight / 3;
		mainCircuitW = worldWidth / 3;
		
		mainCircuitX = - mainCircuitW/2;
		mainCircuitY = - mainCircuitH / 2;
		steelT = 4;
		steelL = 40;
		pieHandle.PIEpauseTimer();
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
	dt = pieHandle.PIEgetDelay()/1000;
	currentTime = currentTime + dt;
	steelT = steelT - dt;
	if (getBulbStatus() && steelT>0)
	{
		resistor.changeSize(steelL, steelT);
		resistor.changeLocation(mainCircuitX + mainCircuitW / 2 - steelL/2, mainCircuitY-steelT/2)
		
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
	var batteryColor:uint;
    /* Set Default Colors */
    slabColor    = 0xFFFFFA;
	bulbColor    = 0xFF2B06;

	batteryColor = 0x0FF000;
	circuitStatus = false;
    circuit = new PIErectangle(pieHandle, mainCircuitX , mainCircuitY, mainCircuitW, mainCircuitH, displayBcolor);
	circuit.changeBorder(2, 0xFFFFFF, 1);
	pieHandle.addDisplayChild(circuit);
	battery1 = new PIEroundedRectangle(pieHandle, mainCircuitX+mainCircuitW/2 - 44, (-mainCircuitY - 5), 20, 10, 0x0FF000);
	pieHandle.addDisplayChild(battery1);
	plusBattery1 = new PIEroundedRectangle(pieHandle, mainCircuitX+mainCircuitW/2 - 24, -mainCircuitY -3, 2, 6, 0x0FF000);
	pieHandle.addDisplayChild(plusBattery1);
	battery2 = new PIEroundedRectangle(pieHandle, mainCircuitX+mainCircuitW/2 -22 , (-mainCircuitY - 5), 20, 10, 0x0FF000);
	pieHandle.addDisplayChild(battery2);
	plusBattery2 = new PIEroundedRectangle(pieHandle, mainCircuitX+mainCircuitW/2 - 2, -mainCircuitY -3, 2, 6, 0x0FF000);
	pieHandle.addDisplayChild(plusBattery2);
	battery3 = new PIEroundedRectangle(pieHandle, mainCircuitX+mainCircuitW/2 , (-mainCircuitY - 5), 20, 10, 0x0FF000);
	pieHandle.addDisplayChild(battery3);
	plusBattery3 = new PIEroundedRectangle(pieHandle, mainCircuitX+mainCircuitW/2 + 20,- mainCircuitY -3, 2, 6, 0x0FF000);
	pieHandle.addDisplayChild(plusBattery3);
	switchBlack = new PIErectangle(pieHandle,mainCircuitX+mainCircuitW/2+30, -mainCircuitY -7, 15, 14, displayBcolor);
	switchBlack.addClickListener(toggleCircuit);
	pieHandle.addDisplayChild(switchBlack);
	switchB = new PIEline(pieHandle, mainCircuitX+mainCircuitW/2+30, -mainCircuitY ,mainCircuitX+mainCircuitW/2+30 + 5, -mainCircuitY- 12, 0xFFFFFF, 4, 1);
	switchB.addClickListener(toggleCircuit);
	pieHandle.addDisplayChild(switchB);
	resistorBlack = new PIErectangle(pieHandle,mainCircuitX+mainCircuitW/2-steelL/2, mainCircuitY -steelT/2, steelL, steelT, displayBcolor);
	pieHandle.addDisplayChild(resistorBlack);
	resistor = new PIErectangle(pieHandle, mainCircuitX + mainCircuitW / 2 - steelL/2, mainCircuitY-steelT/2, steelL , steelT, 0x808080);
	pieHandle.addDisplayChild(resistor);
}



public function toggleCircuit():Boolean
{
	if (circuitStatus)
	{
		pieHandle.PIEpauseTimer();
		circuitStatus = false;
		switchB.changeLine(mainCircuitX+mainCircuitW/2+30, -mainCircuitY , mainCircuitX+mainCircuitW/2+30+5, -mainCircuitY-12);
		return circuitStatus;
	}else
	{
		pieHandle.PIEresumeTimer();
		circuitStatus = true;
		switchB.changeLine(mainCircuitX+mainCircuitW/2+30, -mainCircuitY ,  mainCircuitX+mainCircuitW/2+30 + 15, -mainCircuitY);
		return circuitStatus;
	}
}

public function circuitOff():Boolean {
	if (circuitStatus)
	{
		pieHandle.PIEpauseTimer();
		circuitStatus = false;
		switchB.changeLine(mainCircuitX+mainCircuitW/2+30, -mainCircuitY ,  mainCircuitX+mainCircuitW/2+30 + 5, -mainCircuitY-12);
	}
	return circuitStatus;
}

public function circuitOn():Boolean {
	if (!circuitStatus)
	{
		pieHandle.PIEresumeTimer();
		circuitStatus = true;
		switchB.changeLine(mainCircuitX+mainCircuitW/2+30, -mainCircuitY ,  mainCircuitX+mainCircuitW/2+30 + 15, -mainCircuitY);
	}
	return circuitStatus;
}

public function getBulbStatus():Boolean {
	return circuitStatus;
}





}   /* End of Class experiment */


}


