package ppf.tool.components
{
	import flash.display.Sprite;
	
	import mx.controls.Alert;
	import mx.core.Container;
	import mx.core.UIComponent;
	import mx.events.ValidationResultEvent;
	import mx.validators.Validator;

	/**
	 * 验证表单中的表单验证控件是否都通过验证, 
	 * 被验证的控件必须在FormItem中
	 * @author KK
	 * 
	 */	
	public final class ValidUtil
	{
		/**
		 * 注册验证的错误提示 
		 * @param validators 验证的
		 * @param validateNow 是否立即验证
		 * 
		 */		
		static public function registerValidators(validators:Array,validateNow:Boolean=false):void
		{
			for each (var validator:Validator in validators)
			{
				ErrorTipManager.registerValidator(validator);
			}
			
			if (validateNow)
				Validator.validateAll(validators);
		}
		
		/**
		 * 注销掉错误提示 
		 * @param validators Validator的数组
		 * @param clearErrorString 是否清楚验证的错误提示红框
		 */			
		static public function unregisterValidators(validators:Array,clearErrorString:Boolean=true):void
		{
			for each (var validator:Validator in validators)
			{
				ErrorTipManager.unregisterValidator(validator,clearErrorString);
			}
		}
		/**
		 * 注册验证的错误提示始终显示  
		 * @param popUp 弹出的对象
		 * @param validators 表单验证控件列表
		 * @param hideExistingErrorTips 是否隐藏已经存在的错误提示 默认true
		 * @param validateNow 是否立即验证
		 * 
		 */		
		static public function registerValidatorsOnPopUp(popUp:UIComponent,validators:Array,hideExistingErrorTips:Boolean=false,validateNow:Boolean=false):void
		{
			for each (var validator:Validator in validators)
			{
				ErrorTipManager.registerValidatorOnPopUp(validator,popUp,hideExistingErrorTips);
			}
			if (validateNow)
				Validator.validateAll(validators);
		}
		
		/**
		 * 注销掉错误提示 
		 * @param popUp 弹出的对象
		 * @param validateExistingErrorTips 是否验证已经存在的Validator 
		 * @param clearErrorString 是否清楚验证的错误提示红框
		 */		
		static public function unregisterPopUpValidators(popUp:UIComponent,validateExistingErrorTips:Boolean=false,clearErrorString:Boolean=true):void
		{
			ErrorTipManager.unregisterPopUpValidators(popUp,validateExistingErrorTips,clearErrorString);
		}
		
		/**
		 * 验证表单中的表单验证控件是否都通过验证,
		 * 被验证的控件必须在FormItem中
		 * @param args 表单验证控件列表
		 * @return true:通过，false:不通过
		 * 
		 */		 
		static public function validForm(parentUI:Sprite,isAlert:Boolean, ...args):Boolean
		{
			var validatorErrorArray:Array = Validator.validateAll(args);
			var isValidForm:Boolean = validatorErrorArray.length == 0; 
			if (!isValidForm) 
			{ 
				var errorMessageArray:Array = []; 
				var errField:String;
				for each (var err:ValidationResultEvent in validatorErrorArray) 
				{ 
					if (err.currentTarget.source.parent is Container)
						errField = Container(err.currentTarget.source.parent).label+ ": ";
					else
						errField="";
					errorMessageArray.push(errField  + err.message); 
				} 
				
				if (isAlert)
					Alert.show(errorMessageArray.join("\n\n"), "错误提示", Alert.OK|Alert.NONMODAL, parentUI); 
			} 
			return isValidForm;
		}
		
		public function ValidUtil()
		{
			throw new Error("ValidUtil类只是一个静态方法类!");  
		}
	}
}