package jp.quadro.transition
{
	import flash.display.*;
	import flash.events.*;
	import flash.filters.ColorMatrixFilter;
	import flash.net.*;
	import flash.system.*;
	import flash.utils.getTimer;
	import flash.geom.ColorTransform;
	import com.greensock.TweenMax;
	import com.greensock.TimelineMax;
	import com.greensock.events.TweenEvent;
	import com.greensock.easing.*;
	import com.greensock.plugins.*;

	public class SlopeBlindsEffect extends Sprite
	{
		private var _target:DisplayObject;
		private var _maskList:SlopeBlindsMask;
		private var container:Sprite;
		private var maskContainer:Sprite;
		
		public function SlopeBlindsEffect(target:DisplayObject)
		{
			var nStartX:Number = 0;
			var nStartY:Number = 0;
			var MASK_NUM:uint = 40;
			var MASK_ANGLE:Number = 36;
			
			_target = target;
			
			container = new Sprite();
			container.x = nStartX;
			container.y = nStartY;
			addChild(container);
			
			maskContainer = new Sprite();
			maskContainer.x = nStartX;
			maskContainer.y = nStartY;
			maskContainer.rotation = MASK_ANGLE;
			addChild(maskContainer);
			
			container.addChild(target);
			_target.mask = maskContainer;
			
			var mask_sp:Sprite;
			var nLength:uint;
			var timeLine:TimelineMax = new TimelineMax();
			timeLine.stop();
			
			_maskList = new SlopeBlindsMask(target, MASK_NUM, MASK_ANGLE);
			nLength = _maskList.list.length;
			
			for (var i:uint = 0; i < nLength; i++)
			{
				mask_sp = _maskList.list[ i ];
				mask_sp.scaleX = 0;
				maskContainer.addChild(mask_sp);
				timeLine.insert(new TweenMax(mask_sp, 0.25, {scaleX:1.0, delay : 0.02 * i, ease:Quad.easeOut}));
			}
			
			timeLine.addEventListener(TweenEvent.COMPLETE, tweenComplete);
			timeLine.play();
		}
		
		private function tweenComplete(e:TweenEvent):void 
		{
			removeChild(maskContainer);
			_target.mask = null;
			dispatchEvent(new Event(Event.COMPLETE));
		}
	}
}


import flash.display.*;

class SlopeBlindsMask
{
	private var _originImage:DisplayObject;
	private var _num:uint;
	private var _rot:Number;
	private var _list:Array = new Array();
	
	public function SlopeBlindsMask(_originImage:DisplayObject, _num:uint, _rot:Number)
	{
		this._originImage = _originImage;
		this._num = _num;
		this._rot = _rot;
		
		var size:Object = getMaskSize();		
		var mask_sp:Sprite = new Sprite();
		var nMaskWidth:Number = size.width / _num;
		var nMaskY:Number = -_originImage.width * Math.sin(_rot * Math.PI / 180);
		
		for (var i:uint = 0; i < _num; i++)
		{
			mask_sp = new Sprite();
			mask_sp.y = nMaskY;
			mask_sp.x = nMaskWidth * i;
			mask_sp.graphics.beginFill(0xFFFFFF * Math.random());
			mask_sp.graphics.drawRect(0, 0, Math.ceil(nMaskWidth), size.height);
			mask_sp.graphics.endFill();
			list.push(mask_sp);
		}
	}
	
	private function getMaskSize():Object
	{
		var nW:Number = _originImage.height * Math.cos(_rot * Math.PI / 180) + _originImage.width * Math.cos((90 - _rot) * Math.PI / 180);
		var nH:Number = _originImage.height * Math.sin(_rot * Math.PI / 180) + _originImage.width * Math.sin((90 - _rot) * Math.PI / 180);
		
		return { width:nW, height:nH };
	}
	
	public function get list():Array
	{
		return _list;
	}
	
	public function set list(_list:Array):void
	{
		this._list = _list;
	}
}