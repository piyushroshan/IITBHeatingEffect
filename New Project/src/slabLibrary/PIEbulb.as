package slabLibrary
{
import flash.display.DisplayObject;
import flash.display.Graphics;
import flash.display.Sprite;
import flash.geom.Point;
import pie.uiElements.*;
import pie.graphicsLibrary.*;

/*
 * Lens Class
 * All PIE sprite classes are created by the experiment class
 * All PIE sprite methods are invoked with user space co-ordinates
 * All PIE sprite methods talk to the experiment object in user space co-ordinates
 * All graphics and location points are in stage co-ordinates
 * The PIE classes use PIE transformations to translate betseen user space and stage co-ordinates
 * The Experiment class methods always pass PIE Handle to the methods
 *
 */
public class PIEbulb extends PIEsprite
{
/*
 * Lens Display Objects for stretch and drag operations
 */
private var leftStretch:PIErectangle;
private var rightStretch:PIErectangle;
private var topStretch:PIErectangle;
private var bottomStretch:PIErectangle;
private var middleDrag:PIErectangle;
private var bulbDrag:PIEcircle;
private var plusWire:PIEroundedRectangle;
private var switchB:PIEline;
private var switchBlack:PIErectangle;

private var chosenStretch:PIErectangle;
private var battery:PIEroundedRectangle;
private var plusBattery:PIEroundedRectangle;
private var aPIEstretchBegin:Function;
private var aPIEstretchEnd:Function;
private var aPIEgrab:Function;
private var aPIEdrag:Function;
private var aPIEdrop:Function;
private var stretchable:Boolean;
private var draggable:Boolean;

/*
 * Slab specific Parameters (in user co-ordinate space)
 */ 
private var aOrigin:Point;
private var aBulbRadius:Number;
private var dOrigin:Point;
private var dBulbRadius:Number;
private var bulbStatus:Boolean;

private var dLeftTopX:Number;
private var dRightTopX:Number;

/*
 * Constructor for PIESlab class 
 * Parameters: (parentPie:PIE, centerX:Number, centerY:Number, slabH:Number, slabW:Number, slabT:Number, fillColor:uint)
 * parentPie  - handle to the PIE Object
 * centerX   - X Coordinates of center of slab
 * centerY   - Y Coordinates of center of slab
 * slabH - height of slab
 * slabW - width of slab
 * slabT - thickness of slab
 * fillColor  - Fill color
 */
public function PIEbulb(parentPie:PIE, centerX:Number, centerY:Number, bulbR:Number, fillColor:uint):void
{
    /* Store Original Parameters */
    this.pie          = parentPie;
    aOrigin           = new Point(centerX, centerY);
    this.setAnchor(aOrigin);
    this.aBulbRadius  = bulbR;

    this.changeFill(fillColor, 1.0);
    this.changeBorder(1, 0x0000ff, 0.5);
    this.setPIEborder(true);

    this.stretchable = false;
    this.draggable   = false;

    /* Set default values of PIE sprite */
    //this.enablePIEtransform();
    this.setPIEvisible();

    /* Create and Initialise the elements */
    this.adjustBulbDimensions();
    this.PIEcreateElements();
}

/*
 * Adjust Lens Dimensions()
 * This function computes the locations for drawing the lens and the stretch/drag areas
 */
private function adjustBulbDimensions():void
{
var slabThickness:Number;

    /* First set the Lens Boundaries */
}


private function PIEcreateElements():void
{	
	bulbStatus = false;
    plusWire = new PIEroundedRectangle(this.pie, 5*this.dBulbRadius/4, ( -this.dBulbRadius), (2*this.dBulbRadius), (2*this.dBulbRadius), 0x000000);
	plusWire.disablePIEtransform();
	plusWire.changeBorder(2, 0x00FF00, 0.3);
	this.addChild(plusWire);
	battery = new PIEroundedRectangle(this.pie, 2 * this.dBulbRadius - 10, (this.dBulbRadius - 5), 20, 10, 0x0FF000);
	battery.disablePIEtransform();
	this.addChild(battery);
	plusBattery = new PIEroundedRectangle(this.pie, 2 * this.dBulbRadius + 10-3, (this.dBulbRadius-3), 6, 6, 0x0FF000);
	plusBattery.disablePIEtransform();
	this.addChild(plusBattery);
	switchBlack = new PIErectangle(this.pie, 5 * this.dBulbRadius/2 , (this.dBulbRadius-7), 15, 14, 0x000000);
	switchBlack.disablePIEtransform();
	switchBlack.addClickListener(toggleSwitch);
	this.addChild(switchBlack);
	switchB = new PIEline(this.pie, 5 * this.dBulbRadius / 2, (this.dBulbRadius + 1) , 5 * this.dBulbRadius / 2 + 5, this.dBulbRadius - 10, 0xFFFFFF, 4, 0.5);
	switchB.disablePIEtransform();
	switchB.addClickListener(toggleSwitch);
	switchB.setPIEvisible();
	this.addChild(switchB);
	middleDrag = new PIErectangle(this.pie,this.dBulbRadius / 2 , (( -this.dBulbRadius / 2)), (this.dBulbRadius), (this.dBulbRadius), 0xFF2BD6);
    middleDrag.disablePIEtransform();
	middleDrag.changeBorder(1, 0x000000, 0.5); 
    this.addChild(middleDrag);
	
	bulbDrag = new PIEcircle(this.pie, 0 , 0, dBulbRadius, this.PIEfColor);
	bulbDrag.disablePIEtransform();
	bulbDrag.changeBorder(1, 0x000000, 0.5); 
    this.addChild(bulbDrag);
	
	
	
}

private function adjustElements():void
{
   if (bulbDrag != null) {
	   bulbDrag.changeLocation(0, 0);
	   bulbDrag.changeSize(this.dBulbRadius);
	   middleDrag.changeLocation(( this.dBulbRadius / 2), ( -this.dBulbRadius / 2));
	   middleDrag.changeSize(this.dBulbRadius, this.dBulbRadius);
	   plusWire.changeLocation(5*this.dBulbRadius/4, -this.dBulbRadius);
	   plusWire.changeSize((2 * this.dBulbRadius), (2 * this.dBulbRadius));
	   battery.changeLocation(2 * this.dBulbRadius - 10, (this.dBulbRadius - 5));
	   plusBattery.changeLocation(2 * this.dBulbRadius + 10 - 3, (this.dBulbRadius - 3));
	   switchBlack.changeLocation(5 * this.dBulbRadius/2 , (this.dBulbRadius-7));
	   if (bulbStatus)
			switchB.changeLine(5 * this.dBulbRadius / 2, (this.dBulbRadius) , 5 * this.dBulbRadius / 2 + 15, this.dBulbRadius);
	   else
			switchB.changeLine(5 * this.dBulbRadius / 2, (this.dBulbRadius + 1) , 5 * this.dBulbRadius / 2 + 5, this.dBulbRadius - 10);
   }

    /* Create Graphics */
    if (this.isPIEvisible()) this.PIEcreateGraphics();
}




/* Height */
public function getRadius():Number
{
    return(pie.PIEdisplayToApplicationH(dBulbRadius));
}

/*
 * Override PIEsprite methods
 */
/* Visiblity Control Methods */
public override function setPIEvisible():void
{
    super.setPIEvisible();
    if (leftStretch != null) leftStretch.setPIEvisible();
    if (rightStretch != null) rightStretch.setPIEvisible();
    if (topStretch != null) topStretch.setPIEvisible();
    if (bottomStretch != null) bottomStretch.setPIEvisible();
    if (middleDrag != null) middleDrag.setPIEvisible();
	if (bulbDrag != null) middleDrag.setPIEvisible();
    this.PIEcreateGraphics();
}
public override function setPIEinvisible():void
{
    super.setPIEinvisible();
    if (leftStretch != null) leftStretch.setPIEinvisible();
    if (rightStretch != null) rightStretch.setPIEinvisible();
    if (topStretch != null) topStretch.setPIEinvisible();
    if (bottomStretch != null) bottomStretch.setPIEinvisible();
    if (middleDrag != null) middleDrag.setPIEinvisible();
	if (bulbDrag != null) middleDrag.setPIEinvisible();
    this.graphics.clear();
}

/* Transform Control Methods */
public override function enablePIEtransform():void
{
    super.enablePIEtransform();
    this.transformAtoD();
}
public override function disablePIEtransform():void
{
    super.disablePIEtransform();
    this.transformAtoD();
}

/*
 * This method transforms all variables from application co-ordinates to display co-ordinates
 * It calls two separate methods to change location and graphics (drawing) variables
 */
private function transformAtoD():void
{
    this.transformALtoD();
    this.transformADtoD();
}

/*
 * This method transforms the location variables from application co-ordinates to display co-ordinates
 * The graphics is not changed
 */
private function transformALtoD():void
{
    if (isPIEtransformEnabled())
    {
        dOrigin  = pie.PIEapplicationToDisplay(aOrigin);
    }
    else
    {
        dOrigin  = aOrigin;
    }

    /* Change Position */
    this.x = this.dOrigin.x;
    this.y = this.dOrigin.y;
}

/*
 * This method transforms the size (drawing) variables from application co-ordinates to display co-ordinates
 * The graphics is changed appropriately
 */
private function transformADtoD():void
{
    if (isPIEtransformEnabled())
    {
        this.dBulbRadius  = pie.PIEapplicationToDisplayH(this.aBulbRadius);
    }
    else
    {
        this.dBulbRadius  = this.aBulbRadius;
    }

    /* Adjust Drag and Drop Elements */
    this.adjustBulbDimensions();
    this.adjustElements();

    /* Draw if necessary */
    if (this.isPIEvisible()) this.PIEcreateGraphics();
}

/*
 * Draw Lens
 * Parameters: (void)
 */
public override function PIEcreateGraphics():void
{
var perimeter:uint;
var steps:uint;
var nextX:Number;
var nextY:Number;
var center:Number;

    this.graphics.clear();
    if (this.PIEborder) this.graphics.lineStyle(this.PIEbWidth, this.PIEbColor, this.PIEbOpacity);
    if (this.PIEfill) this.graphics.beginFill(this.PIEfColor, this.PIEfOpacity);

}

public override function changeLocation(centerX:Number, centerY:Number):void
{
    /* Store Changed Location */
    aOrigin = new Point(centerX, centerY);
    this.setAnchor(aOrigin);
    transformALtoD();
}

public function changeRadius(bulbRadius:Number):void
{
    /* Store Changed Location */
    this.aBulbRadius = bulbRadius;
    transformADtoD();
}

public function toggleSwitch():Boolean
{
	if (bulbStatus)
	{
		this.pie.PIEpauseTimer();
		bulbStatus = false;
		bulbDrag.changeFillColor(0xFF2B06);
		switchB.changeLine(5 * this.dBulbRadius / 2, (this.dBulbRadius + 1) , 5 * this.dBulbRadius / 2 + 5, this.dBulbRadius - 10);
		return bulbStatus;
	}else
	{
		this.pie.PIEresumeTimer();
		bulbStatus = true;
		bulbDrag.changeFillColor(0xFFFFFF);
		switchB.changeLine(5 * this.dBulbRadius / 2, (this.dBulbRadius) , 5 * this.dBulbRadius / 2 + 15, this.dBulbRadius);
		return bulbStatus;
	}
}

public function bulbOff():Boolean {
	if (bulbStatus)
	{
		this.pie.PIEpauseTimer();
		bulbStatus = false;
		bulbDrag.changeFillColor(0xFF2B06);
		switchB.changeLine(5 * this.dBulbRadius / 2, (this.dBulbRadius + 1) , 5 * this.dBulbRadius / 2 + 5, this.dBulbRadius - 10);
	}
	return bulbStatus;
}

public function bulbOn():Boolean {
	if (!bulbStatus)
	{
		this.pie.PIEresumeTimer();
		bulbStatus = true;
		bulbDrag.changeFillColor(0xFFFFFF);
		switchB.changeLine(5 * this.dBulbRadius / 2, (this.dBulbRadius) , 5 * this.dBulbRadius / 2 + 15, this.dBulbRadius);
	}
	return bulbStatus;
}

public function getBulbStatus():Boolean 
{
	return bulbStatus;
}
}
/* End of Class PIEbulb */

}

