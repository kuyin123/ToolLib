package ppf.tool.components
{

import mx.controls.dataGridClasses.DataGridListData;
import mx.controls.listClasses.BaseListData;
import mx.core.IUIComponent;
	
/**
 * 
 */
public final class TreeGridListData extends DataGridListData
{
		
	public function TreeGridListData(
		text : String, 
		dataField : String,
		columnIndex : int, 
		uid : String,
		owner : IUIComponent, 
		rowIndex : int = 0)
	{
		super( text, dataField, columnIndex, uid, owner, rowIndex );
	}
	
	
	//----------------------------------
	//  depth
    //----------------------------------

	/**
	 *  The level of the item in the tree. The top level is 1.
	 */
	public var depth:int;

    //----------------------------------
	//  disclosureIcon
    //----------------------------------

	/**
	 *  A Class representing the disclosure icon for the item in the TreeGrid control.
	 */
	public var disclosureIcon:Class;

    //----------------------------------
	//  hasChildren
    //----------------------------------

	/**
	 *  Contains <code>true</code> if the node has children.
	 */
	public var hasChildren:Boolean; 
	
	
	public var hasSibling : Boolean;

    //----------------------------------
	//  icon
    //----------------------------------
	
	/**
	 *  A Class representing the icon for the item in the TreeGrid control.
	 */
	public var icon:Class;

    //----------------------------------
	//  indent
    //----------------------------------

	/**
	 *  The default indentation for this row of the TreeGrid control.
	 */
	public var indent:int;
	
	public var indentationGap:int;

	//----------------------------------
	//  icon
    //----------------------------------
	
	/**
	 *  A String that enumerate the trunk style for the item in the TreeGrid control.
	 */
	public var trunk:String;
	
	public var trunkOffsetTop : Number;
	
	public var trunkOffsetBottom : Number;
	
	public var trunkColor:uint = 0xffffff;
	
    //----------------------------------
	//  node
    //----------------------------------

	/**
	 *  The data for this item in the TreeGrid control.
	 */
	public var item:Object;

    //----------------------------------
	//  open
    //----------------------------------

	/**
	 *  Contains <code>true</code> if the node is open.
	 */
	public var open:Boolean; 
	
} // end class
} // end package