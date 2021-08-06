/**
 *        __       __               __
 *   ____/ /_ ____/ /______ _ ___  / /_
 *  / __  / / ___/ __/ ___/ / __ `/ __/
 * / /_/ / (__  ) / / /  / / /_/ / /
 * \__,_/_/____/_/ /_/  /_/\__, /_/
 *                           / /
 *                           \/
 * http://distriqt.com
 *
 * @author 		Michael (https://github.com/marchbold)
 * @created		28/5/21
 */
package com.apm.client.processes.generic
{
	import com.apm.client.APMCore;
	import com.apm.client.logging.Log;
	
	import flash.desktop.NativeProcess;
	import flash.desktop.NativeProcessStartupInfo;
	import flash.events.IOErrorEvent;
	import flash.events.NativeProcessExitEvent;
	import flash.events.ProgressEvent;
	import flash.filesystem.File;
	
	
	public class ExtractZipWindowsProcess extends ExtractZipAS3Process
	{
		////////////////////////////////////////////////////////
		//  CONSTANTS
		//
		
		private static const TAG:String = "ExtractZipMacOSProcess";
		
		
		////////////////////////////////////////////////////////
		//  VARIABLES
		//
		
		private var _process:NativeProcess;
		
		private var _zipFileRef:File;
		private var _deleteAfter:Boolean = false;
		
		////////////////////////////////////////////////////////
		//  FUNCTIONALITY
		//
		
		public function ExtractZipWindowsProcess( core:APMCore, zipFile:File, outputDir:File )
		{
			super( core, zipFile, outputDir );
		}
		
		
		override public function start():void
		{
			var message:String = "extracting " + _zipFile.nativePath;
			
			if (NativeProcess.isSupported)
			{
				if (_zipFile.extension != "zip")
				{
					// Powershell script can't handle non-zip extension archives so we copy to a .zip tmp file and delete after
					_zipFileRef = new File( _zipFile.nativePath + ".zip" );
					_zipFile.copyTo( _zipFileRef );
					_deleteAfter = true;
				}
				
				var processArgs:Vector.<String> = new Vector.<String>();
				processArgs.push( "-command" );
				processArgs.push( "& \"Expand-Archive\" -Force "
										  + "'" + _zipFileRef.nativePath + "'" + " "
										  + "'" + _outputDir.nativePath + "'" );

				var processStartupInfo:NativeProcessStartupInfo = new NativeProcessStartupInfo();
				processStartupInfo.executable = new File( "C:\\Windows\\System32\\WindowsPowerShell\\v1.0\\powershell.exe" );
				processStartupInfo.arguments = processArgs;
				
				if (!processStartupInfo.executable.exists)
				{
					// Fall back to as3 implementation
					return super.start();
				}
				
				_core.io.showSpinner( message );
				
				_process = new NativeProcess();
				_process.addEventListener( NativeProcessExitEvent.EXIT, onExit );
				_process.addEventListener( ProgressEvent.STANDARD_OUTPUT_DATA, onOutputData );
				_process.addEventListener( ProgressEvent.STANDARD_ERROR_DATA, onErrorData );
				_process.addEventListener( IOErrorEvent.STANDARD_OUTPUT_IO_ERROR, onIOError );
				_process.addEventListener( IOErrorEvent.STANDARD_ERROR_IO_ERROR, onIOError );
				
				_process.start( processStartupInfo );
			}
			else
			{
				super.start();
			}
		}
		
		
		private function onOutputData( event:ProgressEvent ):void
		{
			var data:String = _process.standardOutput.readUTFBytes( _process.standardOutput.bytesAvailable )
					.replace( /\n/g, "" )
					.replace( /\r/g, "" )
					.replace( /\t/g, "" );
			
			_core.io.updateSpinner( "extracting : " + data );
		}
		
		
		private function onErrorData( event:ProgressEvent ):void
		{
			Log.d( TAG, "ERROR: " + _process.standardError.readUTFBytes( _process.standardError.bytesAvailable ) );
		}
		
		
		private function onExit( event:NativeProcessExitEvent ):void
		{
			Log.d( TAG, "Process exited with: " + event.exitCode );
			_core.io.stopSpinner( event.exitCode == 0, "extracted" );
			
			if (_deleteAfter)
			{
				_zipFileRef.deleteFile();
			}
			
			complete();
		}
		
		
		private function onIOError( event:IOErrorEvent ):void
		{
			Log.d( TAG, "IOError: " + event.toString() );
		}
		
		
	}
	
}