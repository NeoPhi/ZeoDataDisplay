/*
 * Copyright (c) 2010 Daniel Rinehart <danielr@neophi.com> [http://danielr.neophi.com/]
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */
package com.neophi.zeo.model
{
    import com.neophi.zeo.util.ColorUtils;

    import flash.events.EventDispatcher;

    import mx.charts.ChartItem;
    import mx.charts.HitData;
    import mx.charts.chartClasses.IAxis;
    import mx.charts.chartClasses.Series;
    import mx.graphics.IFill;
    import mx.graphics.SolidColor;

    public class ZQChartModel extends EventDispatcher
    {

        public var targetZQ:int = 80;

        public var targetPlusMinus:int = 15;

        [Bindable]
        public var graphWidth:int;

        [Bindable]
        public var zeoDataArray:Array;

        [Bindable]
        public var minZQ:int;

        [Bindable]
        public var maxZQ:int;

        private var _zeoDataEntries:Vector.<ZeoDataEntry>;

        private var _containerWidth:int;

        private var _scaleFactor:int = 1;

        public function set zeoDataEntries(zeoDataEntries:Vector.<ZeoDataEntry>):void
        {
            _zeoDataEntries = zeoDataEntries;
            var array:Array = new Array();
            var minZQ:int = int.MAX_VALUE;
            var maxZQ:int = int.MIN_VALUE;

            for each (var zeoDataEntry:ZeoDataEntry in zeoDataEntries)
            {
                array.push(zeoDataEntry);
                minZQ = Math.min(minZQ, zeoDataEntry.zq);
                maxZQ = Math.max(maxZQ, zeoDataEntry.zq);
            }
            zeoDataArray = array;
            this.minZQ = minZQ;
            this.maxZQ = maxZQ;
        }

        public function set containerWidth(containerWidth:int):void
        {
            if (_containerWidth != containerWidth)
            {
                _containerWidth = containerWidth;
                graphWidth = _containerWidth * _scaleFactor;
            }
        }

        public function set scaleFactor(scaleFactor:int):void
        {
            if (_scaleFactor != scaleFactor)
            {
                _scaleFactor = scaleFactor;
                graphWidth = _containerWidth * _scaleFactor;
            }
        }

        public function dataFunction(series:Series, item:ZeoDataEntry, fieldName:String):Object
        {
            if (fieldName == "yValue")
            {
                return item.zq;
            }

            if (fieldName == "xValue")
            {
                return item.sleepDate.valueOf();
            }
            return null;
        }

        public function dataTipFunction(hitData:HitData):String
        {
            var zeoData:ZeoDataEntry = ZeoDataEntry(hitData.item);
            var result:String;
            result = "<b>Date</b>: " + zeoData.sleepDate.valueOf().toLocaleDateString() + "\n";
            result += "<b>ZQ</b>: " + zeoData.zq;
            return result;
        }

        public function labelFunction(labelValue:Date, previousValue:Date, axis:IAxis):String
        {
            return labelValue.toLocaleDateString();
        }

        public function fillFunction(chartItem:ChartItem, index:Number):IFill
        {
            var color:uint = getColor(chartItem.item.zq, targetZQ, targetPlusMinus);

            return (new SolidColor(color, 0.75));
        }

        private function getColor(zq:int, target:int, plusMinus:int):uint
        {
            // light green
            var color:uint = 0x90EE90;
            // dark green
            var above:uint = 0x006400;
            // orange/red
            var below:uint = 0xFF4500;

            if (zq < target)
            {
                if (zq < (target - plusMinus))
                {
                    color = below;
                }
                else
                {
                    color = ColorUtils.interpolateColor(color, below, (target - zq) / plusMinus);
                }
            }

            if (zq > target)
            {
                if (zq > (target + plusMinus))
                {
                    color = above;
                }
                else
                {
                    color = ColorUtils.interpolateColor(color, above, (zq - target) / plusMinus);
                }
            }
            return color;
        }
    }
}