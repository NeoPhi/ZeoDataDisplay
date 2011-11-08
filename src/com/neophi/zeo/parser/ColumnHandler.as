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
package com.neophi.zeo.parser
{
    import com.neophi.error.ErrorChain;
    import com.neophi.zeo.model.ZeoDataEntry;

    /**
     * Handler for a column in a CSV value.
     */
    public class ColumnHandler
    {
        private var _name:String;

        private var _optionalArguments:Array;

        private var _parser:Function;

        private var _propertyName:String;

        /**
         * Construct a new handler instance.
         * @param name Name of the column as defined in the CSV header
         * @param propertyName Name of the property to set on the target object
         * @param parser Function used to parse the raw String value into a more appropriate type
         * @param optionalArguments Optional arguments to pass to the parser function
         */
        public function ColumnHandler(name:String, propertyName:String, parser:Function, ... optionalArguments)
        {
            _name = name;
            _propertyName = propertyName;
            _parser = parser;
            _optionalArguments = optionalArguments;
        }

        /**
         * Verify that the name matches the name assigned to this column handler.
         * @param name Name to check
         * @throws ArgumentError if the name does not match
         */
        public function verifyNameMatches(name:String):void
        {
            if (_name != name)
            {
                throw new ArgumentError("Expected " + _name + " but got " + name + ".");
            }
        }

        /**
         * Parse the value and set it on the data instance.
         * @param zeoData Data instance to update
         * @param value Value to parse and set on the data
         * @throws Error if the value can not be parsed or set on the data instance
         */
        public function setProperty(zeoData:ZeoDataEntry, value:String):void
        {
            try
            {
                var argArray:Array = [value].concat(_optionalArguments);
                var propertyNameParts:Array = _propertyName.split(/\./);
                var target:Object = zeoData;
                var targetPropertyName:String = propertyNameParts.pop();

                for each (var propertyNamePart:String in propertyNameParts)
                {
                    target = target[propertyNamePart];
                }
                target[targetPropertyName] = _parser.apply(ZeoCSVParser, argArray);
            }
            catch (error:Error)
            {
                throw new ErrorChain("Error handling \"" + _propertyName + "\".", 0, error);
            }
        }
    }
}