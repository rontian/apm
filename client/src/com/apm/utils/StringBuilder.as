/*************************************************
 * @author   : rontian
 * @email    : i@ronpad.com
 * @date     : 2023/7/20
 *************************************************/
package com.apm.utils
{

    import flash.events.EventDispatcher;

    public class StringBuilder extends EventDispatcher
    {
        private var _source:String = "";

        public function StringBuilder(prefix:String = "")
        {
            _source = prefix;
        }

        public function append(str:String, ...args):StringBuilder
        {
            var len:int = args.length;
            for(var i:int = 0; i < len; i++)
            {
                str = str.replace(new RegExp("\\{" + i + "\\}", "g"), args[i]);
            }
            _source += str;
            return this;
        }

        public function appendLine(str:String, ...args):StringBuilder
        {
            var len:int = args.length;
            for(var i:int = 0; i < len; i++)
            {
                str = str.replace(new RegExp("\\{" + i + "\\}", "g"), args[i]);
            }
            _source += str + "\n";
            return this;
        }

        public function breakLine():StringBuilder
        {
            _source += "\n";
            return this;
        }

        override public function toString():String
        {
            return _source;
        }
    }
}
