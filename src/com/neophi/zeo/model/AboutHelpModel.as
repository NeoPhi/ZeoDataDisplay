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
    import flash.events.ContextMenuEvent;
    import flash.events.Event;
    import flash.net.URLRequest;
    import flash.net.navigateToURL;
    import flash.ui.ContextMenu;
    import flash.ui.ContextMenuItem;

    import mx.core.UIComponent;

    public class AboutHelpModel
    {
        public static const VERSION:String = "Revision: Nov 7, 2011 (01)";

        public function addContextMenuItems(target:UIComponent):void
        {
            var about:ContextMenuItem = new ContextMenuItem("Created by Daniel Rinehart");
            about.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, handleAboutSelect);

            var contextMenu:ContextMenu = ContextMenu(target.contextMenu);
            contextMenu.customItems.push(about);
            contextMenu.customItems.push(new ContextMenuItem(VERSION));
        }

        public function mailtoClick():void
        {
            navigateToURL(new URLRequest("mailto:danielr@neophi.com"), "_top");
        }

        private function handleAboutSelect(event:Event):void
        {
            navigateToURL(new URLRequest("http://danielr.neophi.com/"), "_blank");
        }
    }
}