package ppf.tool.components.mx.components.controls
{

import ppf.tool.components.mx.components.renderers.TreeGridItemRenderer2;

import mx.controls.dataGridClasses.DataGridColumn;
import mx.core.ClassFactory;
import mx.core.IFactory;

/**
 * 
 */
public class TreeGridColumn extends DataGridColumn
{
	public function TreeGridColumn()
	{
		super();
		
		itemRenderer = new ClassFactory(TreeGridItemRenderer2);
	}

} // end class
} // end package