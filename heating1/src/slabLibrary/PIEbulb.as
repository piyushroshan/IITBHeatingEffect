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

private var chosenStretch:PIErectangle;

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

    this.stretchable = true;
    this.draggable   = true;

    /* Set default values of PIE sprite */
    this.enablePIEtransform();
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
    
	middleDrag = new PIErectangle(this.pie,this.dBulbRadius / 4 , (( -this.dBulbRadius / 4)), (this.dBulbRadius/2), (this.dBulbRadius/2), this.PIEfColor);
    middleDrag.disablePIEtransform();
	middleDrag.changeBorder(1, 0x000000, 0.5); 
    this.addChild(middleDrag);
	bulbDrag = new PIEcircle(this.pie, 0 , 0, dBulbRadius / 2, this.PIEfColor);
	bulbDrag.disablePIEtransform();
	bulbDrag.changeBorder(1, 0x000000, 0.5); 
    this.addChild(bulbDrag);
	
	
	/* Invisible Left Stretch Rectangle */
    leftStretch = new PIErectangle(this.pie, ((-this.dBulbRadius)/2 - 3), (-3), 6, 6, this.PIEfColor+50);
    leftStretch.disablePIEtransform();
    leftStretch.setPIEvisible();
    this.addChild(leftStretch);

    /* Invisible Right Stretch Rectangle */
    rightStretch = new PIErectangle(this.pie, (3*this.dBulbRadius/4 + 3), (-3), 6, 6, this.PIEfColor+50);
    rightStretch.disablePIEtransform();
    rightStretch.setPIEvisible();
    this.addChild(rightStretch);

    /* Invisible Top Stretch Rectangle */
    topStretch = new PIErectangle(this.pie, (-3), ((-this.dBulbRadius) / 2 - 3),  6, 6, this.PIEfColor+50);
    topStretch.disablePIEtransform();
    topStretch.setPIEvisible();
    this.addChild(topStretch);

    /* Invisible Bottom Stretch Rectangle */
    bottomStretch = new PIErectangle(this.pie, (-3) , ((this.dBulbRadius) / 2 + 3),  6, 6, this.PIEfColor+50);
    bottomStretch.disablePIEtransform();
    bottomStretch.setPIEvisible();
    this.addChild(bottomStretch);
}

private function adjustElements():void
{
    /* Invisible Left Stretch Rectangle */
    if (leftStretch != null) leftStretch.changeLocation((-this.dBulbRadius)/2 - 3, (-3));

    /* Invisible Right Stretch Rectangle */
    if (rightStretch != null) rightStretch.changeLocation(3*this.dBulbRadius/4+ 3, (-3));
	
	if (topStretch != null) topStretch.changeLocation((-3), (-this.dBulbRadius)/2 - 3);
    /* Invisible Right Stretch Rectangle */
    if (bottomStretch != null) bottomStretch.changeLocation((-3), (this.dBulbRadius / 2) + 3);

   if (bulbDrag != null) {
	   bulbDrag.changeLocation(0, 0);
	   bulbDrag.changeSize(this.dBulbRadius / 2);
	   middleDrag.changeLocation(( -this.dBulbRadius / 4), ( -this.dBulbRadius / 4));
	   middleDrag.changeSize(this.dBulbRadius,this.dBulbRadius/2);
   }

    /* Create Graphics */
    if (this.isPIEvisible()) this.PIEcreateGraphics();
}

/*
 * Manage Listeners
 */
/*
 * Add Stretch Listener(aStretch:Function)
 * aStretch : Aplication Stretch Handler
 */
public function addStretchListeners(aStretchBegin:Function, aStretchEnd:Function):void
{

    {
        this.aPIEstretchBegin = aStretchBegin;
        this.aPIEstretchEnd   = aStretchEnd;
        leftStretch.addGrabListener(this.handleLGrab);
        leftStretch.addDragListener(this.handleHDrag);
        leftStretch.addDragListener(this.handleHDrop);
        rightStretch.addGrabListener(this.handleRGrab);
        rightStretch.addDragListener(this.handleHDrag);
        rightStretch.addDragListener(this.handleHDrop);
        topStretch.addGrabListener(this.handleTGrab);
        topStretch.addDragListener(this.handleVDrag);
        topStretch.addDragListener(this.handleVDrop);
        bottomStretch.addGrabListener(this.handleBGrab);
        bottomStretch.addDragListener(this.handleVDrag);
        bottomStretch.addDragListener(this.handleVDrop);
    }
}
public function handleLGrab(clickX:Number, clickY:Number):void
{
    this.chosenStretch = leftStretch;
    transformAndStretchBegin(clickX, clickY);
}
public function handleRGrab(clickX:Number, clickY:Number):void
{
    this.chosenStretch = rightStretch;
    transformAndStretchBegin(clickX, clickY);
}
public function handleTGrab(clickX:Number, clickY:Number):void
{
    this.chosenStretch = topStretch;
    transformAndStretchBegin(clickX, clickY);
}
public function handleBGrab(clickX:Number, clickY:Number):void
{
    this.chosenStretch = bottomStretch;
    transformAndStretchBegin(clickX, clickY);
}
public function transformAndStretchBegin(clickX:Number, clickY:Number):void
{
var newPoint:Point;

    if (this.isPIEtransformEnabled())
    {
        newPoint = pie.PIEdisplayToApplication(new Point(clickX, clickY));
        clickX = newPoint.x;
        clickY = newPoint.y;
    }
    if (this.aPIEstretchBegin != null) this.aPIEstretchBegin(clickX, clickY);
}
public function handleHDrag(mouseX:Number, mouseY:Number, displacementX:Number, displacementY:Number):void
{
var newBulbRadius:Number;

    if (this.chosenStretch == this.leftStretch) { newBulbRadius  =  this.dBulbRadius - displacementX; }
    else if (this.chosenStretch == this.rightStretch) { newBulbRadius  =  this.dBulbRadius + displacementX; }

    // if (((2 * this.dLeftThickness) > this.minThickness) && ((2 * this.dLeftThickness) < this.minThickness))
    {
       this.dBulbRadius = newBulbRadius;
	   this.adjustBulbDimensions();
       this.adjustElements();
    }
}
public function handleVDrag(mouseX:Number, mouseY:Number, displacementX:Number, displacementY:Number):void
{
var newSlabHeight:Number;

    if (this.chosenStretch == this.topStretch) { this.dBulbRadius = this.dBulbRadius - displacementY; }
    else if (this.chosenStretch == this.bottomStretch) { this.dBulbRadius = this.dBulbRadius + displacementY; }

    this.adjustBulbDimensions();
    this.adjustElements();
}
public function handleHDrop(mouseX:Number, mouseY:Number, displacementX:Number, displacementY:Number):void
{
    this.handleHDrag(mouseX, mouseY, displacementX, displacementY);
    if (this.isPIEtransformEnabled())
    {
        displacementX = pie.PIEdisplayToApplicationW(displacementX);
    }
    if (this.aPIEstretchEnd != null) this.aPIEstretchEnd(aOrigin.x, aOrigin.y, displacementX, 0);
}
public function handleVDrop(mouseX:Number, mouseY:Number, displacementX:Number, displacementY:Number):void
{
    this.handleVDrag(mouseX, mouseY, displacementX, displacementY);
    if (this.isPIEtransformEnabled())
    {
        displacementY = pie.PIEdisplayToApplicationH(displacementY);
    }
    if (this.aPIEstretchEnd != null) this.aPIEstretchEnd(aOrigin.x, aOrigin.y, 0, displacementY);
}
/*
 * Add Drag Listener(aDrag:Function)
 * aDrag : Aplication Drag Handler
 */
public function addDragListeners(aGrab:Function, aDrag:Function, aDrop:Function):void
{
    this.aPIEgrab = aGrab;
    this.aPIEdrag = aDrag;
    this.aPIEdrop = aDrop;
	bulbDrag.addDragAndDropListeners(this.handleMGrab, this.handleMDrag, this.handleMDrop);
	middleDrag.addDragAndDropListeners(this.handleMGrab, this.handleMDrag, this.handleMDrop);
}
public function handleMGrab(clickX:Number, clickY:Number):void
{
var newPoint:Point;

    if (this.isPIEtransformEnabled())
    {
        newPoint = pie.PIEdisplayToApplication(new Point(clickX, clickY));
        clickX = newPoint.x;
        clickY = newPoint.y;
    }
    if (this.aPIEgrab != null) this.aPIEgrab(clickX, clickY);
}
public function handleMDrag(mouseX:Number, mouseY:Number, displacementX:Number, displacementY:Number):void
{
    dOrigin.x = dOrigin.x + displacementX;
	dOrigin.y = dOrigin.y + displacementY;
    if (this.isPIEtransformEnabled())
    {
        aOrigin = pie.PIEdisplayToApplication(new Point(dOrigin.x, dOrigin.y));
        displacementX = pie.PIEdisplayToApplicationW(displacementX);
		displacementY = pie.PIEdisplayToApplicationH(displacementY);
    }
    else
    {
        aOrigin.x = dOrigin.x;
    }
    this.changeLocation(aOrigin.x, aOrigin.y);
    if (this.aPIEdrag != null) this.aPIEdrag(aOrigin.x, aOrigin.y, displacementX, displacementY);
}
public function handleMDrop(mouseX:Number, mouseY:Number, displacementX:Number, displacementY:Number):void
{
    this.handleMDrag(mouseX, mouseY, displacementX, displacementY);
    if (this.isPIEtransformEnabled())
    {
        displacementX = pie.PIEdisplayToApplicationW(displacementX);
		displacementY = pie.PIEdisplayToApplicationH(displacementY);
    }
    if (this.aPIEdrop != null) this.aPIEdrag(aOrigin.x, aOrigin.y, displacementX, displacementY);
}

/* Height */
public function getRadius():Number
{
    return(this.aBulbRadius);
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

public function changeLocation(centerX:Number, centerY:Number):void
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
		bulbStatus = false;
		return bulbStatus;
	}
	else
	{
		bulbStatus = true;
		return bulbStatus;
	}
}

}   /* End of Class PIEbulb */

}

