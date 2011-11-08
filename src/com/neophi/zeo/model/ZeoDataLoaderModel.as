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
    import com.neophi.parser.CSVParser;
    import com.neophi.zeo.parser.ZeoCSVParser;

    import flash.events.ErrorEvent;
    import flash.events.Event;
    import flash.events.EventDispatcher;
    import flash.events.IOErrorEvent;
    import flash.events.ProgressEvent;
    import flash.events.SecurityErrorEvent;
    import flash.net.FileReference;
    import flash.net.URLLoader;
    import flash.net.URLRequest;

    public class ZeoDataLoaderModel extends EventDispatcher
    {

        [Bindable]
        public var percentLoaded:int;

        [Bindable]
        public var zeoDataEntries:Vector.<ZeoDataEntry>;

        [Bindable]
        public var averageZQ:int;

        [Bindable]
        public var dataLoaded:Boolean;

        [Bindable]
        public var errorMessage:String;

        private var _zeoCSVPaser:ZeoCSVParser = new ZeoCSVParser();

        private var _loadReference:FileReference;

        private var _urlLoader:URLLoader

        public function ZeoDataLoaderModel()
        {
            _zeoCSVPaser.addEventListener(ProgressEvent.PROGRESS, handleParseProgress);
            _zeoCSVPaser.addEventListener(Event.COMPLETE, handleParseComplete);
            _zeoCSVPaser.addEventListener(ErrorEvent.ERROR, handleParseError);
        }

        public function loadFile():void
        {
            _loadReference = new FileReference();
            _loadReference.addEventListener(Event.CANCEL, handleLocalLoadCancel);
            _loadReference.addEventListener(Event.SELECT, handleLocalLoadSelect);
            _loadReference.addEventListener(Event.COMPLETE, handleLocalLoadComplete);
            _loadReference.addEventListener(IOErrorEvent.IO_ERROR, handleLocalLoadError);
            _loadReference.addEventListener(SecurityErrorEvent.SECURITY_ERROR, handleLocalLoadError);
            _loadReference.browse();
        }

        public function loadSample():void
        {
            _urlLoader = new URLLoader();
            _urlLoader.addEventListener(Event.COMPLETE, handleURLLoadComplete);
            resetModel();
            _urlLoader.load(new URLRequest("sample.csv"));
        }

        private function handleLocalLoadCancel(event:Event):void
        {
            _loadReference = null;
        }

        private function handleLocalLoadSelect(event:Event):void
        {
            resetModel();

            try
            {
                _loadReference.load();
            }
            catch (error:Error)
            {
                errorMessage = error.toString();
            }
        }

        private function handleLocalLoadError(errorEvent:ErrorEvent):void
        {
            errorMessage = errorEvent.toString();
        }

        private function handleLocalLoadComplete(event:Event):void
        {
            startParser(String(_loadReference.data));
            _loadReference = null;
        }

        private function handleURLLoadComplete(event:Event):void
        {
            startParser(String(_urlLoader.data));
            _urlLoader = null;
        }

        private function startParser(data:String):void
        {
            var csvParser:CSVParser = new CSVParser(data);
            csvParser.strictTextData = false;
            _zeoCSVPaser.parse(csvParser);
        }

        private function handleParseProgress(progressEvent:ProgressEvent):void
        {
            percentLoaded = int((progressEvent.bytesLoaded / progressEvent.bytesTotal) * 100);
        }

        private function handleParseComplete(event:Event):void
        {
            this.zeoDataEntries = _zeoCSVPaser.result;

            if (this.zeoDataEntries.length > 0)
            {
                var zqSum:Number = 0;

                for each (var zeoData:ZeoDataEntry in this.zeoDataEntries)
                {
                    zqSum += zeoData.zq;
                }
                averageZQ = Math.round(zqSum / this.zeoDataEntries.length);
            }

            dataLoaded = true;
        }

        private function handleParseError(errorEvent:ErrorEvent):void
        {
            errorMessage = errorEvent.toString();
        }

        private function resetModel():void
        {
            errorMessage = null;
            averageZQ = 0;
            percentLoaded = 0;
            zeoDataEntries = null;
            dataLoaded = false;
        }
    }
}