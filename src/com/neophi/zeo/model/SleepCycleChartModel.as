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
    import flash.events.EventDispatcher;

    import mx.charts.chartClasses.CartesianDataCanvas;
    import mx.charts.chartClasses.IAxis;

    public class SleepCycleChartModel extends EventDispatcher
    {

        [Bindable]
        public var zeoDataArray:Array;

        private var _zeoDataEntries:Vector.<ZeoDataEntry>;

        private var _line1:CartesianDataCanvas;

        private var _line2:CartesianDataCanvas;

        public function set zeoDataEntries(zeoDataEntries:Vector.<ZeoDataEntry>):void
        {
            _zeoDataEntries = zeoDataEntries;
            var sum:Vector.<int> = new Vector.<int>();
            var count:Vector.<int> = new Vector.<int>();
            var i:int = 0;

            for each (var zeoDataEntry:ZeoDataEntry in zeoDataEntries)
            {
                var startIndex:int = 0;

                while ((startIndex < zeoDataEntry.detailedSleepGraph.length) && zeoDataEntry.detailedSleepGraph[startIndex].isUnknown())
                {
                    startIndex++;
                }
                var endIndex:int = zeoDataEntry.detailedSleepGraph.length - 1;

                while ((endIndex >= 0) && zeoDataEntry.detailedSleepGraph[endIndex].isUnknown())
                {
                    endIndex--;
                }

                if (endIndex > startIndex)
                {
                    if ((endIndex - startIndex + 1) > sum.length)
                    {
                        sum.length = (endIndex - startIndex + 1);
                        count.length = sum.length;
                    }
                    i = 0;

                    for (var j:int = startIndex; j <= endIndex; j++)
                    {
                        if (!zeoDataEntry.detailedSleepGraph[j].isUnknown())
                        {
                            sum[i] += zeoDataEntry.detailedSleepGraph[j].value;
                            count[i]++;
                        }
                        i++;
                    }
                }
            }

            var array:Array = new Array();

            for (i = 0; i < sum.length; i++)
            {
                if (count[i] < zeoDataEntries.length * .6)
                {
                    break;
                }
                var data:Object = new Object();
                data.period = i / 2;
                data.average = sum[i] / count[i];
                array[i] = data;
            }
            zeoDataArray = array;
        }

        public function set line1(line1:CartesianDataCanvas):void
        {
            if (_line1 != line1)
            {
                _line1 = line1;

                if (_line1 != null)
                {
                    line1.graphics.clear();
                    line1.graphics.lineStyle(2, 0x0000FF);
                    line1.moveTo(30, 1);
                    line1.lineTo(30, 4);
                }
            }
        }

        public function set line2(line2:CartesianDataCanvas):void
        {
            if (_line2 != line2)
            {
                _line2 = line2;

                if (_line2 != null)
                {
                    line2.graphics.clear();
                    line2.graphics.lineStyle(2, 0xFF0000);
                    line2.moveTo(90, 1);
                    line2.lineTo(30, 4);
                }
            }
        }

        public function labelFunction(labelValue:int, previousValue:int, axis:IAxis):String
        {
            switch (labelValue)
            {
                case SleepStage.WAKE.value:
                    return "Wake";
                case SleepStage.REM.value:
                    return "REM";
                case SleepStage.LIGHT.value:
                    return "Light";
                case SleepStage.DEEP.value:
                    return "Deep";
            }
            return "Undefined";
        }
    }
}