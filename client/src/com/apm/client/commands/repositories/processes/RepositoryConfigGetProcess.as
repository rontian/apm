/*************************************************
 * @author   : rontian
 * @email    : i@ronpad.com
 * @date     : 2023/7/27
 *************************************************/
package com.apm.client.commands.repositories.processes
{
    import com.apm.client.APM;
    import com.apm.client.processes.ProcessBase;

    public class RepositoryConfigGetProcess extends ProcessBase
    {
        ////////////////////////////////////////////////////////
        //  CONSTANTS
        //

        private static const TAG:String = "RepositoryConfigGetProcess";

        ////////////////////////////////////////////////////////
        //  VARIABLES
        //

        private var _paramName:String;

        public function RepositoryConfigGetProcess(paramName:String)
        {
            _paramName = paramName;
        }

        override public function start(completeCallback:Function = null, failureCallback:Function = null):void
        {
            super.start(completeCallback, failureCallback);
            var list:Array = APM.config.user.repositoryList;
            var i:int;
            if(_paramName == null)
            {
                APM.io.writeLine("Current Repository Name: ");
                APM.io.writeLine(APM.config.user.currentRepository.toString());
                APM.io.writeLine("")
                APM.io.writeLine("All Repository List: ");
                if(list.length > 0)
                {
                    for(i = 0; i < list.length; i++)
                    {
                        APM.io.writeValue(list[i].name, list[i].url);
                    }
                }
            }
            else
            {
                if(list.length > 0)
                {
                    APM.io.writeLine("Repository Config With " + _paramName + ": ");
                    for(i = 0; i < list.length; i++)
                    {
                        if(list[i].name == _paramName)
                        {
                            APM.io.writeValue(list[i].name, list[i].url);
                            break;
                        }
                    }
                }
                else
                {
                    APM.io.writeLine("No Repository Config");
                }
            }
            complete();
        }
    }
}
