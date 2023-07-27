/*************************************************
 * @author   : rontian
 * @email    : i@ronpad.com
 * @date     : 2023/7/27
 *************************************************/
package com.apm.client.commands.repositories.processes
{
    import com.apm.client.APM;
    import com.apm.client.processes.ProcessBase;

    public class RepositoryConfigAddProgress extends ProcessBase
    {
        ////////////////////////////////////////////////////////
        //  CONSTANTS
        //

        private static const TAG:String = "RepositoryConfigAddProgress";

        ////////////////////////////////////////////////////////
        //  VARIABLES
        //

        private var _repositoryName:String;
        private var _repositoryURL:String;

        public function RepositoryConfigAddProgress(repositoryName:String, repositoryURL:String)
        {
            super();
            _repositoryName = repositoryName;
            _repositoryURL = repositoryURL;
        }

        override public function start(completeCallback:Function = null, failureCallback:Function = null):void
        {
            super.start(completeCallback, failureCallback);
            if(_repositoryName && _repositoryURL)
            {
                var list:Array = APM.config.user.repositoryList;
                var isInserted:Boolean = true;
                for(var i:int = 0; i < list.length; i++)
                {
                    var item:Object = list[i];
                    if(item.name == _repositoryName)
                    {
                        isInserted = false;
                        item.url = _repositoryURL;
                        break;
                    }
                }
                if(isInserted)
                {
                    list.push({
                                  name: _repositoryName,
                                  url: _repositoryURL
                              });
                }
                APM.config.user.repositoryList = list;
                APM.io.writeLine("Add repository config success");
                complete();
            }
            else
            {
                failure("paramName or paramValue is null");
            }
        }
    }
}
