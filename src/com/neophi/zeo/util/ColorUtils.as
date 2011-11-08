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
package com.neophi.zeo.util
{

    /**
     * Utility functions for dealing with color.
     */
    public class ColorUtils
    {
        /**
         * Interpolate between two colors.
         * @param fromColor From Color
         * @param toColor To Color
         * @param progress How far along the transition from fromColor to toColor [0, 1] is the trasnition.
         * @return Color
         */
        public static function interpolateColor(fromColor:uint, toColor:uint, progress:Number):uint
        {
            //
            // found at http://www.actionscript.org/forums/showpost.php3?p=794474&postcount=4
            //
            var q:Number = 1 - progress;
            var fromA:uint = (fromColor >> 24) & 0xFF;
            var fromR:uint = (fromColor >> 16) & 0xFF;
            var fromG:uint = (fromColor >> 8) & 0xFF;
            var fromB:uint = fromColor & 0xFF;
            var toA:uint = (toColor >> 24) & 0xFF;
            var toR:uint = (toColor >> 16) & 0xFF;
            var toG:uint = (toColor >> 8) & 0xFF;
            var toB:uint = toColor & 0xFF;
            var resultA:uint = fromA * q + toA * progress;
            var resultR:uint = fromR * q + toR * progress;
            var resultG:uint = fromG * q + toG * progress;
            var resultB:uint = fromB * q + toB * progress;
            var resultColor:uint = resultA << 24 | resultR << 16 | resultG << 8 | resultB;
            return resultColor;
        }
    }
}