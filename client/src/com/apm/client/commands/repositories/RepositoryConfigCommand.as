/*************************************************
 * @author   : rontian
 * @email    : i@ronpad.com
 * @date     : 2023/7/27
 *************************************************/
package com.apm.client.commands.repositories
{
    import com.apm.client.APM;
    import com.apm.client.commands.Command;
    import com.apm.client.commands.repositories.processes.RepositoryConfigAddProgress;
    import com.apm.client.commands.repositories.processes.RepositoryConfigGetProcess;
    import com.apm.client.commands.repositories.processes.RepositoryConfigSetProcess;
    import com.apm.client.events.CommandEvent;
    import com.apm.client.logging.Log;
    import com.apm.client.processes.ProcessQueue;
    import com.apm.utils.StringBuilder;

    import flash.events.EventDispatcher;

    public class RepositoryConfigCommand extends EventDispatcher implements Command
    {
        ////////////////////////////////////////////////////////
        //  CONSTANTS
        //

        private static const TAG:String = "RepositoryConfigCommand";

        public static const NAME:String = "repository/config";

        ////////////////////////////////////////////////////////
        //  VARIABLES
        //

        private var _parameters:Array;

        public function RepositoryConfigCommand()
        {
            super();
            _parameters = [];
        }

        public function execute():void
        {
            Log.d(TAG, "execute(): [" + (_parameters.length > 0 ? _parameters.join(" ") : " ") + "]\n");
            try
            {
                var queue:ProcessQueue = new ProcessQueue();

                if(_parameters.length > 0)
                {
                    var subCommand:String = _parameters[0];
                    switch(subCommand)
                    {
                        case "set":
                        {
                            queue.addProcess(new RepositoryConfigSetProcess(_parameters[1]));
                            break;
                        }
                        case "add":
                        {
                            if(_parameters.length >= 3)
                            {
                                queue.addProcess(new RepositoryConfigAddProgress(_parameters[1], _parameters[2]));
                            }
                            break;
                        }
                        case "get":
                        {
                            if(_parameters.length < 2)
                            {
                                queue.addProcess(new RepositoryConfigGetProcess(null));
                            }
                            else
                            {
                                queue.addProcess(new RepositoryConfigGetProcess(_parameters[1]));
                            }
                            break;
                        }
                        default:
                        {
                            dispatchEvent(new CommandEvent(CommandEvent.PRINT_USAGE, name));
                            dispatchEvent(new CommandEvent(CommandEvent.COMPLETE, APM.CODE_ERROR));
                            return;
                        }
                    }
                }
                else
                {
                    // print all config
                    queue.addProcess(new RepositoryConfigGetProcess(null));
                }

                queue.start(function ():void
                            {
                                dispatchEvent(new CommandEvent(CommandEvent.COMPLETE, APM.CODE_OK));
                            }, function (error:String):void
                            {
                                APM.io.writeError(NAME, error);
                                dispatchEvent(new CommandEvent(CommandEvent.COMPLETE, APM.CODE_ERROR));
                            });

            }
            catch(e:Error)
            {
                APM.io.error(e);
                dispatchEvent(new CommandEvent(CommandEvent.COMPLETE, APM.CODE_ERROR));
            }
        }

        public function setParameters(parameters:Array):void
        {
            _parameters = parameters;
        }

        public function get name():String
        {
            return NAME;
        }

        public function get category():String
        {
            return "";
        }

        public function get description():String
        {
            return "configuration parameters for respository in .npmconfig file";
        }

        public function get usage():String
        {
            return new StringBuilder(description)
                    .breakLine()
                    .breakLine()
                    .appendLine("apm repository config                              Prints all repository parameters")
                    .appendLine("apm repository config set <repository name>        Set current repository from exists repository list")
                    .appendLine("apm repository config add <name> <repository>      Add a new repository")
                    .appendLine("apm repository config get <name?>                  Get repository by name or all repositories")
                    .toString();
        }

        public function get requiresNetwork():Boolean
        {
            return false;
        }

        public function get requiresProject():Boolean
        {
            return false;
        }
    }
}
