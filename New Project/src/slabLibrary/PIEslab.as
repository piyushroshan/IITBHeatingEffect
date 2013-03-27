package slabLibrary
{
import flash.display.DisplayObject;
import flash.display.Graphics;
import flash.display.Sprite;
import flash.geom.Point;
import pie.uiElements.*;
import pie.graphicsLibrary.*;
import slabLibrary.PIEbulb;

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
public class PIEslab extends PIEsprite
{
/*
 * Lens Display Objects for stretch and drag operations
 */
private var leftStretch:PIErectangle;
private var rightStretch:PIErectangle;
private var topStretch:PIErectangle;
private var bottomStretch:PIErectangle;
private var middleDrag:PIErectangle;
private var mirrorDrag:PIErectangle;

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
private var aSlabHeight:Number;
private var aSlabWidth:Number;
private var aSlabThickness:Number;

private var dOrigin:Point;
private var dSlabHeight:Number;
private var dSlabWidth:Number;
private var dSlabThickness:Number;
private var dLeftTopX:Number;
private var dRightTopX:Number;

private var maxThickness:Number;
private var minThickness:Number;

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
public function PIEslab(parentPie:PIE, centerX:Number, centerY:Number, slabH:Number, slabW:Number, slabT:Number, fillColor:uint):void
{
    /* Store Original Parameters */
    this.pie          = parentPie;
    aOrigin           = new Point(centerX, centerY);
    this.setAnchor(aOrigin);
    this.aSlabHeight  = slabH;
    this.aSlabWidth  = slabW;
    this.aSlabThickness = slabT;

    this.changeFill(fillColor, 1.0);
    this.changeBorder(1, 0x0000ff, 0.5);
    this.setPIEborder(true);
    this.stretchable = false;
    this.draggable   = false;
    this.maxThickness = 10;
    this.minThickness = 2;
    /* Set default values of PIE sprite */
    //this.enablePIEtransform();
    this.setPIEvisible();

    /* Create and Initialise the elements */
  // this.adjustSlabDimensions();
    this.PIEcreateElements();
}


private function adjustSlabDimensions():void
{

}


private function PIEcreateElements():void
{
  
    middleDrag = new PIErectangle(this.pie, ( -this.dSlabWidth / 2), (( -this.dSlabHeight / 2)), (this.dSlabWidth), (this.dSlabHeight), this.PIEfColor);
	middleDrag.setPIEvisible();
	middleDrag.changeBorder(1, 0x000000, 0.5); 
    this.addChild(middleDrag);
	middleDrag.disablePIEtransform();
}

private function adjustElements():void
{
   if (middleDrag != null) {
		middleDrag.changeLocation(( -this.dSlabWidth / 2), (( -this.dSlabHeight / 2)));
		middleDrag.changeSize((this.dSlabWidth), (this.dSlabHeight));
		//mirrorDrag.changeSize((this.dSlabWidth), (this.dSlabHeight));
	}

    /* Create Graphics */
    if (this.isPIEvisible()) this.PIEcreateGraphics();
}


/* Height */
public function getHeight():Number
{
    return(pie.PIEdisplayToApplicationH(this.dSlabHeight));
}

/* Slab Width */
public function getSlabWidth():Number
{
    return(pie.PIEdisplayToApplicationW(this.dSlabWidth));
}
/* Slab Thickness */
public function getSlabThickness():Number
{
    return(this.aSlabThickness);
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
        this.dSlabHeight  = pie.PIEapplicationToDisplayH(this.aSlabHeight);
        this.dSlabWidth  = pie.PIEapplicationToDisplayW(this.aSlabWidth);
        this.dSlabThickness = pie.PIEapplicationToDisplayW(this.aSlabThickness);
    }
    else
    {
        this.dSlabHeight  = this.aSlabHeight;
        this.dSlabWidth  = this.aSlabWidth;
        this.dSlabThickness = this.aSlabThickness;
    }

    /* Adjust Drag and Drop Elements */
    this.adjustSlabDimensions();
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
var startAngle:Number;
var iAngle:Number;
var nextX:Number;
var nextY:Number;
var center:Number;
var theta:Number;

    this.graphics.clear();
    if (this.PIEborder) this.graphics.lineStyle(this.PIEbWidth, this.PIEbColor, this.PIEbOpacity);
    if (this.PIEfill) this.graphics.beginFill(this.PIEfColor, this.PIEfOpacity);

    /* Draw Left Arc */
    
/*
 * Change Slab Location
 * Parameters: (topLeftX:Number , topLeftY:Number) 
 * centerX   - X Coordinates of top left corner
 * centerY   - Y Coordinates of top left corner
 */
}
public override function changeLocation(centerX:Number, centerY:Number):void
{
    /* Store Changed Location */
    aOrigin = new Point(centerX, centerY);
    this.setAnchor(aOrigin);
    transformALtoD();
}

/*
 * Change slab Height
 * Parameters: (slabHeight:Number)
 * slabHeight - Height of lens
 */
public function changeHeight(slabHeight:Number):void
{
    /* Store Changed Location */
    this.aSlabHeight = slabHeight;
    transformADtoD();
}

/*
 * Change slab Width
 * Parameters: (slabWidth:Number)
 * slabHeight - Width of lens
 */
public function changeWidth(slabWidth:Number):void
{
    /* Store Changed Location */
    this.aSlabWidth = slabWidth;
    transformADtoD();
}

public function getOrigin():Point
{
	return aOrigin;
}



}   /* End of Class PIEslab */

}

