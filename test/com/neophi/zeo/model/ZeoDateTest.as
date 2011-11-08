/*
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
    import org.flexunit.asserts.assertFalse;
    import org.flexunit.asserts.assertTrue;

    public class ZeoDateTest
    {
        private var _zeoDate:ZeoDate;

        [Before]
        public function setup():void
        {
            _zeoDate = new ZeoDate(2000, 12, 31);
        }

        [Test]
        public function equals_Null_False():void
        {
            assertFalse(_zeoDate.equals(null));
        }

        [Test]
        public function equals_Self_True():void
        {
            assertTrue(_zeoDate.equals(_zeoDate));
        }

        [Test]
        public function equals_SameYearMonthAndDay_True():void
        {
            var otherDate:ZeoDate = new ZeoDate(2000, 12, 31);

            assertTrue(_zeoDate.equals(otherDate));
        }

        [Test]
        public function equals_SameMonthAndDayDifferentYear_False():void
        {
            var otherDate:ZeoDate = new ZeoDate(1970, 12, 31);
            assertFalse(_zeoDate.equals(otherDate));
        }

        [Test]
        public function equals_SameYearAndDayDifferentMonth_False():void
        {
            var otherDate:ZeoDate = new ZeoDate(2000, 5, 31);
            assertFalse(_zeoDate.equals(otherDate));
        }

        [Test]
        public function equals_SameYearAndMonthDifferentDay_False():void
        {
            var otherDate:ZeoDate = new ZeoDate(2000, 12, 6);
            assertFalse(_zeoDate.equals(otherDate));
        }

        [Test]
        public function equals_SameDayDifferentYearAndMonth_False():void
        {
            var otherDate:ZeoDate = new ZeoDate(1999, 1, 31);
            assertFalse(_zeoDate.equals(otherDate));
        }

        [Test]
        public function equals_SameMonthDifferentYearAndDay_False():void
        {
            var otherDate:ZeoDate = new ZeoDate(2020, 12, 12);
            assertFalse(_zeoDate.equals(otherDate));
        }

        [Test]
        public function equals_SameYearDifferentMonthAndDay_False():void
        {
            var otherDate:ZeoDate = new ZeoDate(2000, 8, 24);
            assertFalse(_zeoDate.equals(otherDate));
        }

        [Test]
        public function equals_DifferentYearMonthAndDay_False():void
        {
            var otherDate:ZeoDate = new ZeoDate(2013, 7, 7);
            assertFalse(_zeoDate.equals(otherDate));
        }
    }
}