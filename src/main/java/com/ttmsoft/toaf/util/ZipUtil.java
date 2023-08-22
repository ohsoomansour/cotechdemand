package com.ttmsoft.toaf.util;

import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.util.Enumeration;
import java.util.List;

import org.apache.commons.io.IOUtils;
import org.apache.commons.lang.StringUtils;
import org.apache.tools.zip.ZipEntry;
import org.apache.tools.zip.ZipFile;
import org.apache.tools.zip.ZipOutputStream;

import com.ttmsoft.toaf.object.FileObject;

//import net.sf.jazzlib.ZipEntry;
//import net.sf.jazzlib.ZipInputStream;
//import net.sf.jazzlib.ZipOutputStream;

@SuppressWarnings ({"rawtypes"})
public class ZipUtil {

	private static final int	COMPRESSION_LEVEL	= 8;
	private static final int	BUFFER_SIZE			= 1024 * 2;

	// 버퍼 사이즈를 정한다. 한번에 1024byte를 읽어온다.
	private static final byte[]	buf					= new byte[BUFFER_SIZE];

	/**
	 * <PRE>
	 * 기  능	: 파일들에 대한 ZIP 압축 
	 * 함수명	: zipFile
	 * 설  명	: 
	 * 2020.03.03.	[sgchoi] - 최초작성
	 * </PRE>
	 * @param srcPath - 압축 대상 파일 또는 디렉토리
	 * @param zipPath - 생성 ZIP파일경로 (파일명포함)
	 * @throws Exception
	 * 
	 * ex) ZipUtil.zipFile("c:/dir/bbb.txt", "c:/test2/test.zip")
	 */
	public static void zipFile (String srcPath, String zipPath) throws Exception {
		File srcFile = new File(srcPath);

		if (!srcFile.isFile() && !srcFile.isDirectory()) { 
			throw new Exception("압축 대상의 파일을 찾을 수가 없습니다."); 
		}

		if (!(StringUtils.substringAfterLast(zipPath, ".")).equalsIgnoreCase("zip")) { 
			throw new Exception("압축 후 저장 파일명의 확장자를 확인하세요!"); 
		}
		File zipFile = new File(zipPath);
		File zipDir = new File(zipFile.getParent());
		zipDir.mkdirs();

		FileOutputStream fos = null;
		BufferedOutputStream bos = null;
		ZipOutputStream zos = null;

		try {
			fos = new FileOutputStream(zipFile);
			bos = new BufferedOutputStream(fos);
			zos = new ZipOutputStream(bos);			
			zos.setLevel(COMPRESSION_LEVEL); // 압축 레벨 : 최대 압축률 9, 디폴트 8
			zos.setEncoding("EUC-KR");
			
			_zipproc(srcFile, srcFile.getParent(), zos); // ZIP 파일 생성
			
			zos.finish();
		}
		finally {
			if (zos != null) zos.close();
			if (bos != null) bos.close();
			if (fos != null) fos.close();
		}
	}

	/**
	 * <PRE>
	 * 기  능	: 파일들에 대한 ZIP 압축 
	 * 함수명	: zipFile
	 * 설  명	: 
	 * 2017. 3. 6.	[insoon] - 최초작성
	 * </PRE>
	 * @param srcList - 압축 대상파일들
	 * @param zipPath - 생성 ZIP파일경로 (파일명포함)
	 * @throws Exception
	 * 
	 * ex)	String[] src = new String[]{"c:/aaa.txt", "c:/dir/bbb.txt", "c:/ccc.txt"}
	 * 		ZipUtil.zipFile(src, "c:/test2/test.zip")
	 */
	public static void zipFile (String[] srcList, String zipPath) throws Exception {
		if (!(StringUtils.substringAfterLast(zipPath, ".")).equalsIgnoreCase("zip")) { 
			throw new Exception("압축 후 저장 파일명의 확장자를 확인하세요!"); 
		}
		File zipFile = new File(zipPath);
		File zipDir = new File(zipFile.getParent());
		zipDir.mkdirs();

		FileOutputStream fos = null;
		BufferedOutputStream bos = null;
		ZipOutputStream zos = null;

		try {
			fos = new FileOutputStream(zipFile);
			bos = new BufferedOutputStream(fos);
			zos = new ZipOutputStream(bos);			
			zos.setLevel(COMPRESSION_LEVEL); // 압축 레벨 : 최대 압축률 9, 디폴트 8
			zos.setEncoding("EUC-KR");
			
			for (int idx = 0; idx < srcList.length; idx++) {
				String srcPath = srcList[idx];
				File srcFile = new File(srcPath);
				
				if (srcFile.isFile() || srcFile.isDirectory()) { 
					_zipproc(srcFile, srcFile.getParent(), zos); // ZIP 파일 생성
				}
			}
			
			zos.finish();
		}
		finally {
			if (zos != null) zos.close();
			if (bos != null) bos.close();
			if (fos != null) fos.close();
		}
	}

	/**
	 * <PRE>
	 * 기  능	: 파일들에 대한 ZIP 압축 
	 * 함수명	: zipFile
	 * 설  명	: 
	 * 2017. 3. 6.	[insoon] - 최초작성
	 * </PRE>
	 * @param srcList - 압축 대상파일들
	 * @param zipPath - 생성 ZIP파일경로 (파일명포함)
	 * @throws Exception
	 * 
	 * ex)	String[] src = new String[]{"c:/aaa.txt", "c:/dir/bbb.txt", "c:/ccc.txt"}
	 * 		ZipUtil.zipFile(src, "c:/test2/test.zip")
	 */
	public static void zipFile (List<FileObject> srcList, String zipPath) throws Exception {
		if (!(StringUtils.substringAfterLast(zipPath, ".")).equalsIgnoreCase("zip")) { 
			throw new Exception("압축 후 저장 파일명의 확장자를 확인하세요!"); 
		}
		File zipFile = new File(zipPath);
		File zipDir = new File(zipFile.getParent());
		zipDir.mkdirs();

		FileOutputStream fos = null;
		BufferedOutputStream bos = null;
		ZipOutputStream zos = null;

		try {
			fos = new FileOutputStream(zipFile);
			bos = new BufferedOutputStream(fos);
			zos = new ZipOutputStream(bos);			
			zos.setLevel(COMPRESSION_LEVEL); // 압축 레벨 : 최대 압축률 9, 디폴트 8
			zos.setEncoding("EUC-KR");
			
			for (FileObject map : srcList) {
				String srcPath = map.getFilePath();
				File srcFile = new File(srcPath);
				
				if (srcFile.isFile()) { // 파일인 경우만 처리 
					BufferedInputStream bis = null;
					try {
						bis = new BufferedInputStream(new FileInputStream(srcFile));
						ZipEntry zentry = new ZipEntry(map.getFileName());
						zentry.setTime(srcFile.lastModified());
						zos.putNextEntry(zentry);

						int cnt = 0;
						while ((cnt = bis.read(buf, 0, BUFFER_SIZE)) != -1) zos.write(buf, 0, cnt);
						zos.closeEntry();
					}
					finally {
						if (bis != null) bis.close();
					}
				}
			}
			
			zos.finish();
		}
		finally {
			if (zos != null) zos.close();
			if (bos != null) bos.close();
			if (fos != null) fos.close();
		}
	}

	//----------------------------------------------------------------------------------------------------
	// 압축 수행
	//----------------------------------------------------------------------------------------------------
	private static void _zipproc (File srcFile, String rootDir, ZipOutputStream zos) throws Exception {
		if (srcFile.isDirectory()) {
			if (srcFile.getName().equalsIgnoreCase(".metadata")) { return; }

			File[] subFiles = srcFile.listFiles();
			for (int idx = 0; idx < subFiles.length; idx++) {
				_zipproc(subFiles[idx], rootDir, zos);
			}
		}
		else {
			BufferedInputStream bis = null;
			try {
				String srcPath = srcFile.getPath();
				String zipName = srcPath.substring(rootDir.length() + 1, srcPath.length());

				bis = new BufferedInputStream(new FileInputStream(srcFile));
				ZipEntry zentry = new ZipEntry(zipName);
				zentry.setTime(srcFile.lastModified());
				zos.putNextEntry(zentry);

				int cnt = 0;
				while ((cnt = bis.read(buf, 0, BUFFER_SIZE)) != -1) zos.write(buf, 0, cnt);
				zos.closeEntry();
			}
			finally {
				if (bis != null) bis.close();
			}
		}
	}


	/**
	 * <PRE>
	 * 기  능	: 압축해제
	 * 함수명	: unzipFile
	 * 설  명	: 
	 * 2017. 3. 6.	[insoon] - 최초작성
	 * </PRE>
	 * @param srcZip - 해제할 압축ZIP파일
	 * @param tgtDir - 해제된 파일을 위해 저장 디렉토리
	 * @throws Exception
	 * ex)	ZipUtil.unZipFile("c:/test/test.zip", "c:/test/");
	 * 		
	 */
	public static void unzipFile (String srcZip, String tgtDir) throws Exception {
		Enumeration entries;
		
		ZipFile zipFile = null;
		InputStream ins = null;
		FileOutputStream fos = null;
		
		String encoding = "UTF-8".equals(System.getProperty("file.encoding"))? "UTF-8" : "EUC-KR";
		try {
			File srcFile = new File(srcZip);
			if (!srcFile.exists()) throw new Exception("해제할 압축파일을 찾을 수가 없습니다.");			
			
			File tgtFile = new File(tgtDir);
			if (!tgtFile.isDirectory()) tgtFile.mkdirs();

			zipFile = new ZipFile(srcZip, encoding);
			entries = zipFile.getEntries();
			while (entries.hasMoreElements()) {
				ZipEntry entry = (ZipEntry) entries.nextElement();
				String entryName = entry.getName();
				File entryFile = new File(tgtFile.getPath()+"/"+entryName);
				
				if (entryFile.exists()) continue;				
				else if (entry.isDirectory()) {
					entryFile.mkdirs();
				}
				else {
					ins = zipFile.getInputStream(entry);
					fos = new FileOutputStream(entryFile);

					IOUtils.copy(ins, fos);
					IOUtils.closeQuietly(ins);
					IOUtils.closeQuietly(fos);

				}
			}

		}
		catch (Exception e) {
			e.printStackTrace();
		}
		finally {
			if (zipFile != null) {
				try {
					zipFile.close();
				}
				catch (IOException ie) {
					ie.printStackTrace();
				}

			}
			IOUtils.closeQuietly(ins);
			IOUtils.closeQuietly(fos);
		}
	}

}
