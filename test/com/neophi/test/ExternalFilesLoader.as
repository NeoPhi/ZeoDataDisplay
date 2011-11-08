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
package com.neophi.test
{
    import flash.events.ErrorEvent;
    import flash.events.Event;
    import flash.events.EventDispatcher;
    import flash.events.IOErrorEvent;
    import flash.events.SecurityErrorEvent;
    import flash.net.URLLoader;
    import flash.net.URLRequest;

    public class ExternalFilesLoader extends EventDispatcher
    {
        private var _filesToLoad:int;

        private var _hadError:Boolean;

        private var _results:Object = new Object();

        public function addFileToLoad(key:String, url:String):void
        {
            _filesToLoad++;
            var urlLoader:URLLoader = new URLLoader();
            urlLoader.addEventListener(Event.COMPLETE, createCompleteHandler(key));
            urlLoader.addEventListener(IOErrorEvent.IO_ERROR, handleError);
            urlLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, handleError);
            urlLoader.load(new URLRequest(url));
        }

        public function getFile(key:String):Object
        {
            return _results[key];
        }

        private function createCompleteHandler(key:String):Function
        {
            return function(event:Event):void
            {
                if (!_hadError)
                {
                    _results[key] = event.target.data;
                    _filesToLoad--;

                    if (_filesToLoad == 0)
                    {
                        dispatchEvent(new Event(Event.COMPLETE));
                    }
                }
            };
        }

        private function handleError(errorEvent:ErrorEvent):void
        {
            _hadError = true;
            dispatchEvent(errorEvent);
        }
    }
}