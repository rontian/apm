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
 * @brief
 * @author 		marchbold
 * @created		12/7/21
 * @copyright	http://distriqt.com/copyright/license.txt
 */
package com.apm.utils
{
	import com.apm.SemVer;
	import com.apm.data.packages.PackageVersion;

	import flash.filesystem.File;

	public class PackageFileUtils
	{
		////////////////////////////////////////////////////////
		//  CONSTANTS
		//

		private static const TAG:String = "PackageFileUtils";

		public static const AIRPACKAGEEXTENSION:String = "airpackage";


		public static const AIRPACKAGE_SWC_DIR:String = "swc";
		public static const AIRPACKAGE_ANE_DIR:String = "ane";
		public static const AIRPACKAGE_SRC_DIR:String = "src";

		public static const AIRPACKAGE_ASSETS:String = "assets";
		public static const AIRPACKAGE_PLATFORMS:String = "platforms";


		////////////////////////////////////////////////////////
		//  VARIABLES
		//


		////////////////////////////////////////////////////////
		//  FUNCTIONALITY
		//

		public function PackageFileUtils()
		{
		}


		public static function directoryForPackage( packagesDir:String, identifier:String ):File
		{
			var packageDir:File = new File( packagesDir + File.separator + identifier );
			return packageDir;
		}


		public static function filenameForPackage( packageVersion:PackageVersion ):String
		{
			var filename:String = packageVersion.packageDef.identifier + "_" + packageVersion.version.toString() + "." + AIRPACKAGEEXTENSION;
			return filename;
		}


		public static function fileForPackage( packagesDir:String, packageVersion:PackageVersion ):File
		{
			return directoryForPackage( packagesDir, packageVersion.packageDef.identifier )
					.resolvePath(
							PackageFileUtils.filenameForPackage( packageVersion )
					);
		}


		public static function fileForPackageFromIdentifierVersion( packagesDir:String, identifier:String, version:SemVer ):File
		{
			return directoryForPackage( packagesDir, identifier )
					.resolvePath(
							filenameForPackageFromIdentifierVersion( identifier, version )
					);
		}


		public static function filenameForPackageFromIdentifierVersion( identifier:String, version:SemVer ):String
		{
			var filename:String = identifier + "_" + version.toString() + "." + AIRPACKAGEEXTENSION;
			return filename;
		}


		//
		//	LOCAL CONTENTS
		//


		/**
		 * Extracted package location for access to package contents
		 *
		 * @param packagesDir
		 * @param identifier
		 * @return
		 */
		public static function contentsDirForPackage( packagesDir:String, identifier:String ):File
		{
			return directoryForPackage( packagesDir, identifier )
					.resolvePath( contentsDirName() );
		}


		/**
		 * Name of directory to use to extract the contents of a package
		 *
		 * @return
		 */
		public static function contentsDirName():String
		{
			return "contents";
		}





	}

}
