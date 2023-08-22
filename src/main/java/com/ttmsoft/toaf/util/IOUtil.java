package com.ttmsoft.toaf.util;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.io.OutputStreamWriter;
import java.io.Reader;
import java.io.StringReader;
import java.io.StringWriter;
import java.io.Writer;
import java.sql.Clob;

public class IOUtil {

	public static void copy (InputStream in, OutputStream out) throws IOException {
		int c = -1;
		while ((c = in.read()) != -1) {
			out.write(c);
		}
		out.flush();
	}

	public static void copy (Reader in, Writer out) throws IOException {
		int c = -1;
		while ((c = in.read()) != -1) {
			out.write(c);
		}
		out.flush();
	}

	public static String readContents (InputStream in, String charsetName) throws IOException {
		StringWriter writer = new StringWriter();
		Reader reader = null;
		try {
			reader = new BufferedReader(new InputStreamReader(in, charsetName));
			copy(reader, writer);
		}
		finally {
			if (reader != null) try {
				reader.close();
			}
			catch (IOException iex) {}
			if (writer != null) try {
				writer.close();
			}
			catch (IOException iex) {}
		}
		return writer.toString();
	}

	public static void writeContents (OutputStream out, String charsetName, String text) throws IOException {
		BufferedReader reader = null;
		BufferedWriter writer = null;
		try {
			reader = new BufferedReader(new StringReader(text));
			writer = new BufferedWriter(new OutputStreamWriter(out, charsetName));
			copy(reader, writer);
		}
		finally {
			if (reader != null) try {
				reader.close();
			}
			catch (IOException iex) {}
			if (writer != null) try {
				writer.close();
			}
			catch (IOException iex) {}
		}
	}

	/**
	 * Clob 형식의 오브젝트를 String 으로 변환
	 * <PRE>
	 * 사용예 :
	 * DataMap resultMap = this.templateDao.doGetTemplate(~)
	 * String content = clobToString(resultMap.get("content"));
	 * resultMap.put("content", content);
	 * return resultMap;
	 * </PRE>
	 * @param dataMap
	 * @return
	 */
	public static String clobToString (Object clob) {
		int len;
		char page[] = new char[4096];
		StringBuffer clobString = new StringBuffer();
		
		try {
			Clob result = (Clob) clob;
			Reader reader = result.getCharacterStream();
			while ((len = reader.read(page, 0, 4096)) != -1) {
				clobString.append(new String(page, 0, len));
			}
		}
		catch (Exception e) {
			e.printStackTrace();
			return "";
		}
		return clobString.toString();
	}


}
