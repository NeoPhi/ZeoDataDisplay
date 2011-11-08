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
package com.neophi.zeo.view
{
    import com.neophi.zeo.model.SleepStage;
    import com.neophi.zeo.util.ColorUtils;

    import flash.display.Graphics;
    import flash.geom.Point;

    import mx.core.IDataRenderer;
    import mx.skins.ProgrammaticSkin;

    /**
     * Code adpated from: mx.charts.renderers.ShadowLineRenderer
     */
    public class MultipleColorLineRenderer extends ProgrammaticSkin implements IDataRenderer
    {
        private static const UNDEFINED:uint = 0x000000;

        private static const WAKE:uint = 0xFF4500;

        private static const REM:uint = 0x90EE90;

        private static const LIGHT:uint = 0xB0C4DE;

        private static const DEEP:uint = 0x006400;

        /**
         *  @private
         *  Storage for the data property.
         */
        private var _data:Object;

        /**
         *  Constructor.
         *
         *  @langversion 3.0
         *  @playerversion Flash 9
         *  @playerversion AIR 1.1
         *  @productversion Flex 3
         */
        public function MultipleColorLineRenderer()
        {
            super();

            filters = [];
        }

        /**
         *  The chart item that this renderer represents.
         *  ShadowLineRenderers assume that this value
         *  is an instance of LineSeriesItem.
         *  This value is assigned by the owning series.
         */
        public function get data():Object
        {
            return _data;
        }

        /**
         *  @private
         */
        public function set data(value:Object):void
        {
            _data = value;

            invalidateDisplayList();
        }

        /**
         *  @private
         */
        override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
        {
            super.updateDisplayList(unscaledWidth, unscaledHeight);

            graphics.clear();

            drawPolyLine(graphics, _data.items, _data.start, _data.end + 1, "x", "y");
        }


        /**
         * Code adpated from: mx.charts.chartClasses.GraphicsUtilities
         */
        private function drawPolyLine(g:Graphics, pts:Array /* of Object */, start:int, end:int, hProp:String, vProp:String):void
        {
            if (start == end)
            {
                return;
            }

            var len:Number;
            var incr:int;
            var i:int;
            var w:Number;
            var c:Number;
            var a:Number;

            var reverse:Boolean = start > end;

            if (reverse)
            {
                incr = -1;
            }
            else
            {
                incr = 1;
            }

            g.moveTo(pts[start][hProp], pts[start][vProp]);

            var innerEnd:int = end - incr;

            // Check for coincident points at the head of the list.
            // We'll skip over any of those			
            while (start != end)
            {
                if (pts[start + incr][hProp] != pts[start][hProp] || pts[start + incr][vProp] != pts[start][vProp])
                {
                    break;
                }
                start += incr;
            }

            if (start == end || start + incr == end)
            {
                return;
            }

            if (Math.abs(end - start) == 2)
            {
                g.lineTo(pts[start + incr][hProp], pts[start + incr][vProp]);
                return;
            }

            var tanLeft:Point = new Point();
            var tanRight:Point = new Point();
            var tangentLengthPercent:Number = 0.25;

            if (reverse)
            {
                tangentLengthPercent *= -1;
            }

            var j:int = start;

            // First, find the normalized vector
            // from the 0th point TO the 1st point
            var v1:Point = new Point();
            var v2:Point = new Point(pts[j + incr][hProp] - pts[j][hProp], pts[j + incr][vProp] - pts[j][vProp]);
            var tan:Point = new Point();
            var p1:Point = new Point();
            var p2:Point = new Point();
            var mp:Point = new Point();

            len = Math.sqrt(v2.x * v2.x + v2.y * v2.y);
            v2.x /= len;
            v2.y /= len;

            // Now later on we'll be using the tangent to the curve
            // to define the control point.
            // But since we're at the end, we don't have a tangent.
            // Instead, we'll just use the first segment itself as the tangent.
            // The effect will be that the first curve will start along the
            // polyline.
            // Now extend the tangent to get a control point.
            // The control point is expressed as a percentage
            // of the horizontal distance beteen the two points.
            var tanLenFactor:Number = pts[j + incr][hProp] - pts[j][hProp];

            var prevNonCoincidentPt:Object = pts[j];

            // Here's the basic idea.
            // On any given iteration of this loop, we're going to draw the
            // segment of the curve from the nth-1 sample to the nth sample.
            // To do that, we're going to compute the 'tangent' of the curve
            // at the two samples.
            // We'll use these two tangents to find two control points
            // between the two samples.
            // Each control point is W pixels along the tangent at the sample,
            // where W is some percentage of the horizontal distance
            // between the samples.
            // We then take the two control points, and find the midpoint
            // of the line between them.
            // Then we're ready to draw.
            // We draw two quadratic beziers, one from sample N-1
            // to the midpoint, with control point N-1, and one
            // from the midpoint to sample N, with the control point N.

            for (j += incr; j != innerEnd; j += incr)
            {
                // Check and see if the next point is coincident.
                // If it is, we'll skip forward.
                if (pts[j + incr][hProp] == pts[j][hProp] && pts[j + incr][vProp] == pts[j][vProp])
                {
                    continue;
                }

                // v1 is the normalized vector from the nth point
                // to the nth-1 point.
                // Since we already computed from nth-1 to nth,
                // we can just invert it.
                v1.x = -v2.x
                v1.y = -v2.y;

                // Now compute the normalized vector from nth to nth+1. 
                v2.x = pts[j + incr][hProp] - pts[j][hProp];
                v2.y = pts[j + incr][vProp] - pts[j][vProp];

                len = Math.sqrt(v2.x * v2.x + v2.y * v2.y);
                v2.x /= len;
                v2.y /= len;

                // Now compute the 'tangent' of the C1 curve
                // formed by the two vectors.
                // Since they're normalized, that's easy to find...
                // It's the vector that runs between the two endpoints.
                // We normalize it, as well.
                tan.x = v2.x - v1.x;
                tan.y = v2.y - v1.y;
                var tanlen:Number = Math.sqrt(tan.x * tan.x + tan.y * tan.y);
                tan.x /= tanlen;
                tan.y /= tanlen;

                // Optionally, if the vertical direction of the curve
                // reverses itself, we'll pin the tangent to be  horizontal.
                // This works well for typical, well spaced chart lines,
                // not so well for arbitrary curves.
                if (v1.y * v2.y >= 0)
                {
                    tan = new Point(1, 0);
                }

                // Find the scaled tangent we'll use
                // to calculate the control point.
                tanLeft.x = -tan.x * tanLenFactor * tangentLengthPercent;
                tanLeft.y = -tan.y * tanLenFactor * tangentLengthPercent;

                g.lineStyle(2, getColor(pts[j].item.average));

                if (j == (incr + start))
                {
                    // The first segment starts along the polyline,
                    // so we only draw a single quadratic.
                    //					g.moveTo(pts[j - incr].x, pts[j - incr].y);
                    g.curveTo(pts[j][hProp] + tanLeft.x, pts[j][vProp] + tanLeft.y, pts[j][hProp], pts[j][vProp]);
                }
                else
                {
                    // Determine the two control points...
                    p1.x = prevNonCoincidentPt[hProp] + tanRight.x;
                    p1.y = prevNonCoincidentPt[vProp] + tanRight.y;

                    p2.x = pts[j][hProp] + tanLeft.x;
                    p2.y = pts[j][vProp] + tanLeft.y;

                    // and the midpoint of the line between them.
                    mp.x = (p1.x + p2.x) / 2
                    mp.y = (p1.y + p2.y) / 2;

                    // Now draw our two quadratics.
                    g.curveTo(p1.x, p1.y, mp.x, mp.y);
                    g.curveTo(p2.x, p2.y, pts[j][hProp], pts[j][vProp]);

                }

                // We're about to move on to the nth to the nth+1 segment
                // of the curve...so let's flip the tangent at n,
                // and scale it for the horizontal distance from n to n+1.
                tanLenFactor = pts[j + incr][hProp] - pts[j][hProp];
                tanRight.x = tan.x * tanLenFactor * tangentLengthPercent;
                tanRight.y = tan.y * tanLenFactor * tangentLengthPercent;
                prevNonCoincidentPt = pts[j];
            }

            // Now in theory we're going to draw our last curve,
            // which, like the first, is only a single quadratic,
            // ending at the last sample.
            // If we try and draw two curves back to back, in reverse order,
            // they don't quite match.
            // I'm not sure whether this is expected, based on the definition
            // of a quadratic bezier, or a bug in the player.
            // Regardless, to work around this, we'll draw the last segment
            // backwards.
            g.lineStyle(2, getColor(pts[j].item.average));
            g.curveTo(prevNonCoincidentPt[hProp] + tanRight.x, prevNonCoincidentPt[vProp] + tanRight.y, pts[j][hProp], pts[j][vProp]);
        }

        private function getColor(average:Number):uint
        {
            var from:uint;
            var to:uint;
            var progress:Number = average;

            while (progress > 1)
            {
                progress -= 1;
            }

            if (average < SleepStage.WAKE.value)
            {
                from = UNDEFINED;
                to = WAKE;
            }
            else if (average < SleepStage.REM.value)
            {
                from = WAKE;
                to = REM;
            }
            else if (average < SleepStage.LIGHT.value)
            {
                from = REM;
                to = LIGHT;
            }
            else if (average < SleepStage.DEEP.value)
            {
                from = LIGHT;
                to = DEEP;
            }
            else
            {
                from = DEEP;
                to = UNDEFINED;
            }
            return ColorUtils.interpolateColor(from, to, progress);
        }
    }
}
