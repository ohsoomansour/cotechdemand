package com.ttmsoft.toaf.util;

import java.io.BufferedOutputStream;
import java.io.ByteArrayInputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.util.HashMap;
import java.util.Map;
import java.util.UUID;
import org.apache.commons.lang.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.util.Assert;

@SuppressWarnings ({"rawtypes", "unchecked"})
public final class FileUtil_back {

	/**
	 * Logging output for this class
	 */
	private static final Logger	logger				= LoggerFactory.getLogger(FileUtil_back.class);
	public static final int		BUFFER_SIZE			= 4096;

	public static final String 	upload_file_path	= "C:/sts-4.5.1.RELEASE/workspace/LMS_TTM/src/main/webapp/upload";

	/**
	 * Create folders on the file system representing the given path.
	 * 
	 * @param path
	 *            The String representing the folders path
	 * @return boolean <code>true</code> if folders were created successfully, <code>false</code> otherwise
	 */
	 
	public static boolean makeDirs (String path) {
		logger.debug(" Attempting to create folders for path: {}", path);

		if (StringUtils.isNotEmpty(path)) {
			File f = new File(path);

			if (!f.exists() && !f.isDirectory()) {
				logger.warn(" Path does not exist on the file system. Creating folders...");
				return f.mkdirs();
			}
			else {
				logger.warn(" Path already existing on the file system. Exiting...");
			}
		}

		return false;
	}

	/**
	 * Remove the folders represented by the given path from the file system. If flag is <code>true</code> folders are only
	 * removed if empty.
	 * 
	 * @param path
	 *            The String representing the path to remove
	 * @param flag
	 *            The flag specifying if folders should be removed even if not empty
	 * @return boolean <code>true</code> if folders were removed successfully, <code>false</code> otherwise
	 * @todo implement flag
	 */
	public static boolean removeDirs (String path, boolean flag) {
		logger.debug(" Attempting to remove folders for path: {}", path);

		if (StringUtils.isNotEmpty(path)) {
			File f = new File(path);

			if (f.exists() && f.isDirectory() && (f.listFiles().length < 1)) {
				logger.warn(" Path exists on the file system and is empty. Resuming...");
				return f.delete();
			}
			else {
				logger.warn(" Directory folders are not empty. Aborting remove action");
			}
		}

		return false;
	}

	/**
	 * @param fromFile
	 * @param toFile
	 * @return
	 * @update 2010/02/22
	 */

	public static boolean moveFile (String fromFile, String realDir, String toFile) {

		makeDirs(realDir);

		if (!copyFile(fromFile, toFile)) { return false; }
		if (!deleteFile(fromFile)) { return false; }

		return true;
	}

	/*---------------------------------------------------------------------------
	   Copy File
	---------------------------------------------------------------------------*/
	public static boolean copyFile (String fromFile, String toFile) {
		FileOutputStream fos = null;
		FileInputStream fis = null;
		try {
			// retrieve the file data
			fos = new FileOutputStream(toFile);
			fis = new FileInputStream(fromFile);

			byte[] buffer = new byte[BUFFER_SIZE];
			int bytesRead = fis.read(buffer, 0, BUFFER_SIZE);

			while (bytesRead != -1) {
				fos.write(buffer, 0, bytesRead);
				bytesRead = fis.read(buffer, 0, BUFFER_SIZE);
			}
		}
		catch (FileNotFoundException fnfe) {
			return false;
		}
		catch (Exception ioe) {
			return false;
		}
		finally {
			if (fis != null) {
				try {
					fis.close();
				}
				catch (IOException e) {
					logger.warn(e.getMessage());
				}
			}
			if (fos != null) {
				try {
					fos.close();
				}
				catch (IOException e) {
					logger.warn(e.getMessage());
				}
			}
		}

		return true;
	}

	/**
	 * Return the File specified outPathName parameter using given byte[] parameter. It don't validate the outPathName. So This
	 * method may throw the IOException.
	 * 
	 * @param in
	 * @param outPathName
	 * @throws IOException
	 */
	public static void copyFile (byte[] in, String outPathName) throws IOException {
		Assert.notNull(in, "No input byte array specified");
		File out = new File(outPathName);
		copyFile(in, out);
	}

	/**
	 * Return the File specified outPathName parameter using given byte[] parameter. It don't validate the outPathName. So This
	 * method may throw the IOException.
	 * 
	 * @param in
	 * @param outPathName
	 * @throws IOException
	 */
	public static Map<String, Object> saveFile (byte[] in, String originFileName, String fileFolder) throws IOException {
		Assert.notNull(in, "No input byte array specified");
		Map<String, Object> resultMap = new HashMap();

		String basePath = upload_file_path;

		String modFileName = UUID.randomUUID().toString();
		String realfilePath = basePath + fileFolder + "/" + modFileName;
		String filePath = basePath + fileFolder;

		resultMap.put("fileName", originFileName);
		resultMap.put("realName", modFileName);
		resultMap.put("filePath", filePath);
		resultMap.put("basePath", basePath);

		File out = new File(realfilePath);
		copyFile(in, out);

		return resultMap;
	}

	public static void copyFile (byte[] in, File out) throws IOException {
		Assert.notNull(in, "No input byte array specified");
		Assert.notNull(out, "No output File specified");
		ByteArrayInputStream inStream = new ByteArrayInputStream(in);
		OutputStream outStream = new BufferedOutputStream(new FileOutputStream(out));
		copyFile(inStream, outStream);
	}

	public static int copyFile (InputStream in, OutputStream out) throws IOException {
		Assert.notNull(in, "No InputStream specified");
		Assert.notNull(out, "No OutputStream specified");
		try {
			int byteCount = 0;
			byte[] buffer = new byte[BUFFER_SIZE];
			int bytesRead = in.read(buffer);
			while (bytesRead != -1) {
				out.write(buffer, 0, bytesRead);
				byteCount += bytesRead;
				bytesRead = in.read(buffer);
			}
			out.flush();
			return byteCount;
		}
		finally {
			try {
				in.close();
			}
			catch (IOException ex) {
				logger.warn("Could not close InputStream", ex);
			}
			try {
				out.close();
			}
			catch (IOException ex) {
				logger.warn("Could not close OutputStream", ex);
			}
		}
	}

	public static byte[] getFileToByteArray (String fullFilePath) {
		Assert.notNull(fullFilePath, "No input byte array specified");

		FileInputStream fis = null;
		byte[] out = null;
		try {
			fis = new FileInputStream(fullFilePath);
			out = new byte[fis.available()];

			fis.read(out);
		}
		catch (FileNotFoundException e) {
			// e.printStackTrace(); throw e;
			logger.warn("FileNotFoundException");
		}
		catch (IOException e) {
			// e.printStackTrace(); throw e;
			logger.warn("IOException");
		}
		catch (Exception e) {
			// e.printStackTrace(); throw e;
			logger.warn("Exception");
		}
		finally {
			if (fis != null) {
				try {
					fis.close();
				}
				catch (IOException e) {
					logger.warn("closeIOException");
				}
			}
		}
		return out;
	}

	/*---------------------------------------------------------------------------
	   Delete File
	---------------------------------------------------------------------------*/
	public static boolean deleteFile (String fullFilePath) {
		File file;

		file = new File(fullFilePath);

		try {
			if (file.exists()) {
				file.delete();
			}
		}
		catch (SecurityException e) {
			logger.warn("Security Exception when trying to delete file {}", fullFilePath);
			return false;
		}

		return true;
	}

	/*
	public static void main (String[] args) throws IOException {

		String file = PropertiesUtil.getValue("file_base_path");
		// logger.debug(file);
		// String file = "C:/Users/mina/Desktop/web.xml";
		//
		// byte[] b = getFileToByteArray(file);
		// copyFile(b, "C:/Users/mina/Desktop/aaweb.xml");
		logger.debug(file);
		logger.debug("OK");
	}
	*/

}
