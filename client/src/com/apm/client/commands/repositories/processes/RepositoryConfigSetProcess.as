/*************************************************
 * @author   : rontian
 * @email    : i@ronpad.com
 * @date     : 2023/7/27
 *************************************************/
package com.apm.client.commands.repositories.processes
{
    import com.apm.client.APM;
    import com.apm.client.processes.ProcessBase;

    public class RepositoryConfigSetProcess extends ProcessBase
    {
        ////////////////////////////////////////////////////////
        //  CONSTANTS
        //

        private static const TAG:String = "RepositoryConfigSetProcess";

        ////////////////////////////////////////////////////////
        //  VARIABLES
        //

        private var _repositoryName:String;

        public function RepositoryConfigSetProcess(repositoryName:String)
        {
            super();
            _repositoryName = repositoryName;
        }

        override public function start(completeCallback:Function = null, failureCallback:Function = null):void
        {
            super.start(completeCallback, failureCallback);
            if(_repositoryName)
            {
                var list:Array = APM.config.user.repositoryList;
                for(var i:int = 0; i < list.length; i++)
                {
                    if(list[i].name == _repositoryName)
                    {
                        APM.config.user.currentRepository = _repositoryName;
                        APM.io.writeLine("Set current repository is " + _repositoryName);
                        complete();
                        return;
                    }
                }
                failure("repository name is not exist");
            }
            else
            {
                failure("repository name is empty");
            }
        }
    }
}
