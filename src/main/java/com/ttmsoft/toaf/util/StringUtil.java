/*
 * Copyright 2008-2009 MOPAS(Ministry of Public Administration and Security). Licensed under the Apache License, Version
 * 2.0 (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the
 * License at http://www.apache.org/licenses/LICENSE-2.0 Unless required by applicable law or agreed to in writing,
 * software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 * KIND, either express or implied. See the License for the specific language governing permissions and limitations
 * under the License.
 */
package com.ttmsoft.toaf.util;

import java.io.UnsupportedEncodingException;
import java.util.ArrayList;
import java.util.regex.Pattern;

import org.apache.commons.codec.binary.Base64;

/**
 * <PRE>
 * 기  능	: 문자열을 처리하는 유틸 클래스
 * 파일명	: StringUtil.java
 * 패키지	: ttmsoft.toaf.util
 * 설  명	: 전자정부프레임웍 참조
 * 변경이력	:
 * 2015.03.03	[PUDDING] - 최초작성
 * </PRE>
 */
@SuppressWarnings ({ "rawtypes", "unchecked" })
public class StringUtil {

	/**<PRE>
	 * 기  능	: equals와 동일한 기능  
	 * 함수명	: eq
	 * 설  명	: StringUtil.eq("abc", "abc"); // true
	 * </PRE>
	 * @param str1
	 * @param str2
	 * @return
	 */
	public static boolean eq (String str1, String str2) {
		return trim(str1).equals(trim(str2));
	}

	/**<PRE>
	 * 기  능	: equals와 동일한 기능  
	 * 함수명	: equals
	 * 설  명	: StringUtil.equals("abc", "abc"); // true
	 * </PRE>
	 * @param str1
	 * @param str2
	 * @return
	 */
	public static boolean equals (String str1, String str2) {
		return trim(str1).equals(trim(str2));
	}

	/**<PRE>
	 * 기  능	: 문자열 공백 여부
	 * 함수명	: isEmpty
	 * 설  명	: StringUtil.isEmpty(""); // true
	 * 	StringUtil.isEmpty(null); // true
	 * </PRE>
	 * @param str
	 * @return
	 */
	public static boolean isEmpty (String str) {
		return str == null || str.length() == 0;
	}

	/**<PRE>
	 * 기  능	: 문자열 공백 여부 (trim처리후)
	 * 함수명	: isNull
	 * 설  명	: StringUtil.isNull("  "); // true
	 * 	StringUtil.isNull(null); // true
	 * 	StringUtil.isNull("ab"); // false
	 * </PRE>
	 * @param str
	 * @return
	 */
	public static boolean isNull (String str) {
		return str == null || "".equals(str.trim());
	}

	public static boolean isAlpha (String str) {
		if (isNull(str)) return false;
		int sz = str.length();
		for (int i = 0; i < sz; i++) {
			if (!Character.isLetter(str.charAt(i))) { return false; }
		}
		return true;
	}

	public static boolean isAlphaNumeric (String str) {
		if (isNull(str)) return false;
		int sz = str.length();
		for (int i = 0; i < sz; i++) {
			if (!Character.isLetterOrDigit(str.charAt(i))) { return false; }
		}
		return true;
	}

	public static boolean isNumeric (String str) {
		if (isNull(str)) return false;
		int sz = str.length();
		for (int i = 0; i < sz; i++) {
			if (!Character.isDigit(str.charAt(i))) { return false; }
		}
		return true;
	}

	/**<PRE>
	 * 기  능	: RegExp 문자열 비교
	 * 함수명	: isPattern
	 * 설  명	: StringUtil.isPattern("abcdefabc", "^def"); // false
	 * 	StringUtil.isPattern("abcdefabc", "^abc.*$"); // true
	 * </PRE>
	 * @param str - 비교 문자열
	 * @param pattern - 매칭 regexp패턴
	 * @return
	 * @throws Exception
	 */
	public static boolean isPattern (String str, String pattern) throws Exception {
		return (isNull(str)) ? false : Pattern.matches(pattern, str);
	}

	/**<PRE>
	 * 기  능	: RegExp 문자열 비교
	 * 함수명	: isMatch
	 * 설  명	: StringUtil.isMatch("abcdefabc", "*def*"); // true
	 * 	StringUtil.isMatch("abcdefabc", "def*"); // false
	 * </PRE>
	 * @param str - 비교 문자열
	 * @param pattern - 매칭 * 패턴
	 * @return
	 * @throws Exception
	 */
	public static boolean isMatch (String str, String pattern) throws Exception {
		if (pattern.indexOf('*') >= 0) {
			pattern = pattern.replaceAll("\\*", ".*");
		}
		pattern = "^" + pattern + "$";

		return (isNull(str)) ? false : Pattern.matches(pattern, str);
	}

	public static String toStr (int val) {
		return ("" + val);
	}

	public static String toStr (long val) {
		return String.valueOf(val);
	}

	public static String toStr (float val) {
		return String.valueOf(val);
	}

	public static String toStr (double val) {
		return String.valueOf(val);
	}

	public static int toInt (String str) {
		return (isNull(str)) ? 0 : Integer.parseInt(str);
	}

	public static float toFloat (String str) {
		return (isNull(str)) ? 0.0F : Float.parseFloat(str);
	}

	public static double toDouble (String str) {
		return (isNull(str)) ? 0.0D : Double.parseDouble(str);
	}

	public static long toLong (String str) {
		return (isNull(str)) ? 0L : Long.parseLong(str);
	}

	/**<PRE>
	 * 기  능	: underScore -> camelCase 표기법으로 변경
	 * 함수명	: toCamelCase
	 * 설  명	: StringUtil.toCamelCase("eat_apple_milk"); // eatAppleMilk
	 * </PRE>
	 * @param str - 변경문자열
	 * @return
	 */
	public static String toCamelCase (String str) {
		StringBuffer result = new StringBuffer();
		boolean isUpper = false;
		String lowStr = str.toLowerCase();

		for (int i = 0; i < lowStr.length(); i++) {
			char idxChar = lowStr.charAt(i);
			if (idxChar == '_') isUpper = true;
			else {
				if (isUpper) {
					idxChar = Character.toUpperCase(idxChar);
					isUpper = false;
				}
				result.append(idxChar);
			}
		}
		return result.toString();
	}

	/**<PRE>
	 * 기  능	: camelCase -> underScore 표기법으로 변경
	 * 함수명	: toUnderScore
	 * 설  명	: StringUtil.toUnderScore("eatAppleMilk"); // eat_apple_milk
	 * </PRE>
	 * @param str - 변경문자열
	 * @return
	 */
	public static String toUnderScore (String camelCase) {
		String result = "";
		for (int i = 0; i < camelCase.length(); i++) {
			char idxChar = camelCase.charAt(i);
			if (i > 0 && Character.isUpperCase(idxChar)) result = result.concat("_");
			result = result.concat(Character.toString(idxChar).toLowerCase());
		}
		return result;
	}

	/**<PRE>
	 * 기  능	: 문자열 양쪽 공백 제거 (null 과 "" 동일)
	 * 함수명	: trim
	 * 설  명	: StringUtil.trim(" abc "); // "abc"
	 *	StringUtil.trim(null); // ""
	 * </PRE>
	 * @param str - 변경문자열
	 * @return
	 */
	public static String trim (String str) {
		return (isNull(str)) ? "" : str.trim();
	}

	/**<PRE>
	 * 기  능	: Object 문자열 양쪽 공백 제거 (null 과 "" 동일)
	 * 함수명	: trim
	 * 설  명	: dataMap.put("data", "abc"); 
	 *	StringUtil.trim(dataMap.get("data")); // "abc"
	 * </PRE>
	 * @param str - 변경Object
	 * @return
	 */
	public static String trim (Object obj) {
		return (obj != null && !"".equals(obj.toString())) ? obj.toString().trim() : "";
	}

	/**<PRE>
	 * 기  능	: 문자열 좌측 공백 제거 (null 과 "" 동일)
	 * 함수명	: trim
	 * 설  명	: StringUtil.ltrim(" abc "); // "abc "
	 *	StringUtil.trim(null); // ""
	 * </PRE>
	 * @param str - 변경문자열
	 * @return
	 */
	public static String ltrim (String str) {
		int index = 0;
		while (' ' == str.charAt(index++));
		if (index > 0) str = str.substring(index - 1);
		return str;
	}

	/**<PRE>
	 * 기  능	: 문자열 우측 공백 제거 (null 과 "" 동일)
	 * 함수명	: trim
	 * 설  명	: StringUtil.rtrim(" abc "); // " abc"
	 *	StringUtil.trim(null); // ""
	 * </PRE>
	 * @param str - 변경문자열
	 * @return
	 */
	public static String rtrim (String str) {
		int index = str.length();
		while (' ' == str.charAt(--index));
		if (index < str.length()) str = str.substring(0, index + 1);
		return str;
	}

	/**<PRE>
	 * 기  능	: 문자열 합치기 
	 * 함수명	: concat
	 * 설  명	: StringUtil.concat("abc", "xyz"); // "abcxyz"
	 * </PRE>
	 * @param str1 - 문자열
	 * @param str2 - 문자열
	 * @return
	 */
	public static String concat (String str1, String str2) {
		StringBuffer sb = new StringBuffer(str1);
		sb.append(str2);
		return sb.toString();
	}

	/**<PRE>
	 * 기  능	: 좌측 문자 채우기
	 * 함수명	: lpad
	 * 설  명	: StringUtil.lpad("", 3, 'z'); // "zzz"
	 *	StringUtil.lpad(null, 3, 'z'); // "zzz"
	 *	StringUtil.lpad("100", 5, '0'); // "00100"
	 * </PRE>
	 * @param str - 작업문자열
	 * @param len - 결과문자열 크기
	 * @param pad - 대치문자
	 * @return
	 */
	public static String lpad (String str, int len, char pad) {
		return lpad(str, len, pad, false);
	}

	/**<PRE>
	 * 기  능	: 좌측 문자 채우기
	 * 함수명	: lpad
	 * 설  명	: StringUtil.lpad("  ", 3, 'z', true); // "zzz"
	 *	StringUtil.lpad(null, 3, 'z', true); // "zzz"
	 *	StringUtil.lpad(" 100 ", 5, '0', true); // "00100"
	 * </PRE>
	 * @param str - 작업문자열
	 * @param len - 결과문자열 크기
	 * @param pad - 대치문자
	 * @param istrim - 공백제거 유무
	 * @return
	 */
	public static String lpad (String str, int len, char pad, boolean istrim) {
		if (isNull(str)) str = "";
		if (istrim) str = str.trim();
		for (int i = str.length(); i < len; i++) str = pad + str;
		return str;
	}

	/**<PRE>
	 * 기  능	: 우측 문자 채우기
	 * 함수명	: rpad
	 * 설  명	: StringUtil.rpad(" x", 3, 'z'); // " xz"
	 *	StringUtil.rpad(null, 3, 'z'); // "zzz"
	 *	StringUtil.rpad("102", 5, '0'); // "10200"
	 * </PRE>
	 * @param str - 작업문자열
	 * @param len - 결과문자열 크기
	 * @param pad - 대치문자
	 * @return
	 */
	public static String rpad (String str, int len, char pad) {
		return rpad(str, len, pad, false);
	}

	/**<PRE>
	 * 기  능	: 우측 문자 채우기
	 * 함수명	: rpad
	 * 설  명	: StringUtil.rpad(" t ", 3, 'z', true); // "tzz"
	 *	StringUtil.rpad(null, 3, 'z', true); // "zzz"
	 *	StringUtil.rpad(" 102 ", 5, '0', true); // "10200"
	 * </PRE>
	 * @param str - 작업문자열
	 * @param len - 결과문자열 크기
	 * @param pad - 대치문자
	 * @param istrim - 공백제거 유무
	 * @return
	 */
	public static String rpad (String str, int len, char pad, boolean istrim) {
		if (isNull(str)) str = "";
		if (istrim) str = str.trim();
		for (int i = str.length(); i < len; i++) str = str + pad;
		return str;
	}

	/**<PRE>
	 * 기  능	: 문자열을 역순으로 변환 
	 * 함수명	: reverse
	 * 설  명	: StringUtil.reverse("가나다"); // "다나가"
	 * </PRE>
	 * @param str - 작업문자열
	 * @return
	 */
	public static String reverse (String str) {
		return str == null ? null : (new StringBuffer(str)).reverse().toString();
	}

	/**<PRE>
	 * 기  능	: 검색된 문자열 개수
	 * 함수명	: countOf
	 * 설  명	: StringUtil.countOf("aaabxx bbxxxaab", "xx"); // 2
	 * </PRE>
	 * @param str - 작업문자열
	 * @param qry - 검색키워드
	 * @return
	 */
	public static int countOf (String str, String qry) {
		int len = qry.length();
		int cnt = 0;
		for (int idx = str.indexOf(qry); idx >= 0; idx = str.indexOf(qry, idx + len))
			cnt++;
		return cnt;
	}

	/**<PRE>
	 * 기  능	: BASE64 인코딩 수행
	 * 함수명	: encodeStr
	 * 설  명	: StringUtil.encodeStr("Amzi 123"); // "QW16aSAxMjM="
	 * </PRE>
	 * @param str - 작업문자열
	 * @return
	 */
	public static String encodeStr (String str) {
		return new String(Base64.encodeBase64String(str.getBytes())).trim();
	}

	/**<PRE>
	 * 기  능	: BASE64 디코딩 수행
	 * 함수명	: decodeStr
	 * 설  명	: StringUtil.decodeStr("QW16aSAxMjM="); // "Amzi 123"
	 * </PRE>
	 * @param str - 작업문자열
	 * @return
	 */
	public static String decodeStr (String str) {
		return new String(Base64.decodeBase64(str));
	}

	/**<PRE>
	 * 기  능	: 구분자 기준으로 마지막 문자열 
	 * 함수명	: lastStr
	 * 설  명	: StringUtil.lastStr("/data/upload/file.gif", "/"); // "file.gif"
	 * </PRE>
	 * @param str - 작업문자열
	 * @param sep - 구분자 (문자열 가능)
	 * @return
	 */
	public static String lastStr (String str, String sep) {
		if (isNull(str) || isNull(sep)) return "";
		int pos = str.lastIndexOf(sep);
		return pos != -1 && pos != str.length() - sep.length() ? str.substring(pos + sep.length()) : "";
	}

	/**<PRE>
	 * 기  능	: 문자열 부분 자르기
	 * 함수명	: substring
	 * 설  명	: StringUtil.substring("abc", 0); // "abc"
	 *	StringUtil.substring("abc", 2); // "c"
	 *	StringUtil.substring("abc", 4); // ""
	 *	StringUtil.substring("abc", -2); // "bc"
	 *	StringUtil.substring("abc", -4); // "abc"
	 * </PRE>
	 * @param str - 작업문자열
	 * @param spos - 시작위치
	 * @return
	 */
	public static String substring (String str, int spos) {
		if (isNull(str)) return "";
		if (spos < 0) spos += str.length();
		if (spos < 0) spos = 0;
		return spos > str.length() ? "" : str.substring(spos);
	}

	/**<PRE>
	 * 기  능	: 문자열 부분 자르기
	 * 함수명	: substring
	 * 설  명	: StringUtil.substring("abc", 0, 2); // "ab"
	 *	StringUtil.substring("abc", 2, 0); // ""
	 *	StringUtil.substring("abc", 2, 4); // "c"
	 *	StringUtil.substring("abc", 4, 6); // ""
	 *	StringUtil.substring("abc",-2,-1); // "b"
	 *	StringUtil.substring("abc",-4, 2); // "ab"
	 * </PRE>
	 * @param str - 작업문자열
	 * @param spos - 시작위치
	 * @param epos - 끝위치
	 * @return
	 */
	public static String substring (String str, int spos, int epos) {
		if (isNull(str)) return "";
		if (epos < 0) epos += str.length();
		if (spos < 0) spos += str.length();
		if (epos > str.length()) epos = str.length();
		return (spos > epos) ? "" : str.substring((spos < 0 ? 0 : spos), (epos < 0 ? 0 : epos));
	}

	/**<PRE>
	 * 기  능	: 구분자로 구분된 배열 만들기
	 * 함수명	: split
	 * 설  명	: StringUtil.split("a.b.c", "."); // ["a", "b", "c"]
	 *	StringUtil.split("a..b.c", "."); // ["a", "b", "c"]
	 *	StringUtil.split("a||b||c", "||"); // ["a", "b", "c"]
	 * </PRE>
	 * @param str - 작업문자열
	 * @param div - 구분자
	 * @return
	 */
	public static String[] split (String str, String div) {
		return split(str, div, -1, false);
	}

	/**<PRE>
	 * 기  능	: 구분자로 구분된 배열 만들기
	 * 함수명	: split
	 * 설  명	: StringUtil.split("a.b.c", ".", false); // ["a", "b", "c"]
	 *	StringUtil.split("a..b.c", ".", false); // ["a", "b", "c"]
	 *	StringUtil.split("a..b.c", ".", true); // ["a", "", "b", "c"]
	 * </PRE>
	 * @param str - 작업문자열
	 * @param div - 구분자
	 * @param useEmpty - 빈값 배열유지 여부
	 * @return
	 */
	public static String[] split (String str, String div, boolean useEmpty) {
		return split(str, div, -1, useEmpty);
	}

	/**<PRE>
	 * 기  능	: 구분자로 구분된 배열 만들기
	 * 함수명	: split
	 * 설  명	: StringUtil.split("ab:cd:ef", ":", 2); // ["ab", "cd:ef"]
	 *	StringUtil.split("ab:cd:ef", ":", 0); // ["ab", "cd", "ef"]
	 *	StringUtil.split("ab   cd ef", null, 0); // ["ab", "cd", "ef"]
	 * </PRE>
	 * @param str - 작업문자열
	 * @param div - 구분자
	 * @param max - 최대배열수
	 * @return
	 */
	public static String[] split (String str, String div, int max) {
		return split(str, div, max, false);
	}

	/**<PRE>
	 * 기  능	: 구분자로 구분된 배열 만들기
	 * 함수명	: split
	 * 설  명	: StringUtil.split("ab:cd:ef", ":", 2, false); // ["ab", "cd:ef"]
	 *	StringUtil.split("ab::cd:ef:", ":", 0, true); // ["ab", "", "cd", "ef", ""]
	 * </PRE>
	 * @param str - 작업문자열
	 * @param div - 구분자
	 * @param max - 최대배열수
	 * @param useEmpty - 빈값 배열유지 여부
	 * @return
	 */
	public static String[] split (String str, String div, int max, boolean useEmpty) {
		if (isNull(str)) return new String[0];

		int slen = str.length();
		int dlen = div.length();
		int idx = 0, spos = 0, epos = 0;
		ArrayList list = new ArrayList();

		while (epos < slen) {
			epos = str.indexOf(div, spos);
			if (epos > -1) {
				if (epos > spos) {
					idx += 1;
					if (idx == max) { list.add(str.substring(spos)); epos = slen; }
					else { list.add(str.substring(spos, epos)); spos = epos + dlen; }
				}
				else {
					if (useEmpty) {
						idx += 1;
						if (idx != max) list.add("");
						else { list.add(str.substring(spos)); epos = slen; }
					}
					spos = epos + dlen;
				}
			}
			else { list.add(str.substring(spos)); epos = slen; }
		}
		return (String[]) list.toArray(new String[list.size()]);
	}

	/**<PRE>
	 * 기  능	: 배열을 구분자로 구분된 문자열 생성
	 * 함수명	: join
	 * 설  명	: StringUtil.join(["a", "b", "c"]); // "a,b,c"
	 *	StringUtil.join([null, "", "c"]); // ",,c"
	 * </PRE>
	 * @param list - 배열 Object[]
	 * @return
	 */
	public static String join (Object[] list) {
		return join((Object[]) list, ",");
	}

	/**<PRE>
	 * 기  능	: 배열을 구분자로 구분된 문자열 생성
	 * 함수명	: join
	 * 설  명	: StringUtil.join(["a", "b", "c"], ":"); // "a:b:c"
	 *	StringUtil.join([null, "", "c"], ","); // ",,c"
	 * </PRE>
	 * @param list - 배열 Object[]
	 * @param sep - 구분자
	 * @return
	 */
	public static String join (Object[] list, String sep) {
		return list == null ? null : join(list, sep, 0, list.length);
	}

	/**<PRE>
	 * 기  능	: 배열을 구분자로 구분된 문자열 생성
	 * 함수명	: join
	 * 설  명	: StringUtil.join(["a", "b", "c"], ":", 0, 2); // "a:b"
	 *	StringUtil.join([null, "b", "c"], "-", 1, 3); // "b-c"
	 * </PRE>
	 * @param list - 배열 Object[]
	 * @param sep - 구분자
	 * @param spos - 배열시작위치
	 * @param epos - 배열종료위치
	 * @return
	 */
	public static String join (Object[] list, String sep, int spos, int epos) {
		int bufSize = epos - spos;
		if (list == null || list.length == 0 || bufSize <= 0) return "";
		if (sep == null) sep = "";

		bufSize *= (list[spos] == null ? 16 : list[spos].toString().length()) + sep.length();
		StringBuffer buf = new StringBuffer(bufSize);

		for (int i = spos; i < epos; ++i) {
			if (i > spos) buf.append(sep);
			if (list[i] != null) buf.append(list[i]);
		}

		return buf.toString();
	}

	/**<PRE>
	 * 기  능	: 문자열 바꾸기 (한번만) 
	 * 함수명	: replaceOnce
	 * 설  명	: StringUtil.replaceOnce("abcd abcd", "ab", "x"); // "xcd abcd"
	 * </PRE>
	 * @param text - 작업 문자열
	 * @param searchStr - 검색 문자열
	 * @param replaceStr - 바꿀 문자열
	 * @return
	 */
	public static String replaceOnce (String text, String searchStr, String replaceStr) {
		return replace(text, searchStr, replaceStr, 1);
	}

	/**<PRE>
	 * 기  능	: 문자열 바꾸기
	 * 함수명	: replace
	 * 설  명	: StringUtil.replace("abcd abcd", "ab", "x"); // "xcd xcd"
	 * </PRE>
	 * @param text - 작업 문자열
	 * @param searchStr - 검색 문자열
	 * @param replaceStr - 바꿀 문자열
	 * @return
	 */
	public static String replace (String text, String searchStr, String replaceStr) {
		return replace(text, searchStr, replaceStr, -1);
	}

	/**<PRE>
	 * 기  능	: 문자열 바꾸기
	 * 함수명	: replace
	 * 설  명	: StringUtil.replace("abab abab", "ab", "x", 3); // "xx xab"
	 * </PRE>
	 * @param text - 작업 문자열
	 * @param searchStr - 검색 문자열
	 * @param replaceStr - 바꿀 문자열
	 * @param max - 최대 교체수
	 * @return
	 */
	public static String replace (String text, String searchStr, String replaceStr, int max) {
		if (!isEmpty(text) && !isEmpty(searchStr) && replaceStr != null && max != 0) {
			int spos = 0, epos = text.indexOf(searchStr, spos);
			if (epos == -1) return text;

			int len = searchStr.length();
			int inc = replaceStr.length() - len;
			inc = inc < 0 ? 0 : inc;
			inc *= max < 0 ? 16 : (max > 64 ? 64 : max);

			StringBuffer buf;
			for (buf = new StringBuffer(text.length() + inc); epos != -1; epos = text.indexOf(searchStr, spos)) {
				buf.append(text.substring(spos, epos)).append(replaceStr);
				spos = epos + len; --max;
				if (max == 0) break;
			}

			buf.append(text.substring(spos));
			return buf.toString();
		}
		else {
			return text;
		}
	}
	
	
	/**<PRE>
	 * 기  능	: 문자열 글자수 기반 자르기 (한글, 줄임문자열) 
	 * 함수명	: strcut
	 * 설  명	: StringUtil.strcut("한글 제목입니다.", 9, ".."); // "한글 제목.."
	 * </PRE>
	 * @param str - 작업 문자열
	 * @param max - 최대 글자수 (알파벳 문자기준) 
	 * @param trail - 줄임문자열 (...)
	 * @return
	 */
	public static String strcut(String str, int max, String trail) {
		return strcut(str, max, trail, "UTF-8");
	}

	public static String strcut(String str, int max, String trail, String charType) {
		if (isNull(str)) return "";
		
		String result = "";
		try {
			byte strByte[] = str.getBytes(charType);
			if (strByte.length <= max) return str;
	
			int epos = 0;
			int cidx = 0;
			for (int i = 0; i < str.length(); i++) {
				char ch = str.charAt(i);
				cidx = cidx + charSize(ch);
				if (cidx > max) {
					epos = cidx - charSize(ch);
					break;
				}
			}
			byte newByte[] = new byte[epos];
			System.arraycopy(strByte, 0, newByte, 0, epos);
			result = new String(newByte, charType);
			result += trail;
		}
		catch (UnsupportedEncodingException e) {
			e.printStackTrace();
		}
		return result;
	}

	/**<PRE>
	 * 기  능	: BYTE기준 문자크기
	 * 함수명	: charSize
	 * 설  명	: StringUtil.charSize('A');
	 * </PRE>
	 * @param c
	 * @return
	 */
	public static int charSize(char c) {
		int digit = (int) c;
		if (0x0000 <= digit && digit <= 0x007F) return 1;
		else if (0x0800 <= digit && digit <= 0x07FF) return 2;
		else if (0x0800 <= digit && digit <= 0xFFFF) return 3;
		else if (0x10000 <= digit && digit <= 0x10FFFF) return 4;
		return -1;
	}
	
	/**<PRE>
	 * 기  능	: HTML 태그 제거
	 * 함수명	: removeHtml
	 * 설  명	: StringUtil.removeHtml("<p>Hello</p>"); // "Hello"
	 * </PRE>
	 * @param html
	 * @return
	 */
	public static String removeHtml(String html) {
		if (isNull(html)) return "";		
//		return html.replaceAll("<(/)?([a-zA-Z]*)(\\s[a-zA-Z]*=[^>]*)?(\\s)*(/)?>", "");
		
		Pattern SCRIPT = Pattern.compile("<(no)?script[^>]*>.*?</(no)?script>",Pattern.DOTALL);
		Pattern STYLE = Pattern.compile("<style[^>]*>.*</style>",Pattern.DOTALL);
		Pattern TAGS = Pattern.compile("<(\"[^\"]*\"|\'[^\']*\'|[^\'\">])*>");
//		Pattern nTAGS = Pattern.compile("<\\w+\\s+[^<]*\\s*>");
		Pattern ENTITYREFS = Pattern.compile("&[^;]+;");
		Pattern WHITESPACE = Pattern.compile("\\s\\s+");
		
		html = SCRIPT.matcher(html).replaceAll("");
		html = STYLE.matcher(html).replaceAll("");
		html = TAGS.matcher(html).replaceAll("");
		html = ENTITYREFS.matcher(html).replaceAll("");
		html = WHITESPACE.matcher(html).replaceAll(" ");

		return html;
	}

	/**<PRE>
	 * 기  능	: 엔터(\n) 를 BR태그로 변환 
	 * 함수명	: cr2br
	 * 설  명	: StringUtil.cr2br("abc\ndef"); // abc<br/>def
	 * 2017. 3. 10.	[pudding] - 최초작성
	 * </PRE>
	 * @param str
	 * @return
	 */
	public static String cr2br(String str) {
		return (isNull(str))? "" : str.replaceAll("(\r\n|\n)", "<br/>");		
	}

	/**
	 * <PRE>
	 * 기  능	: 숫자형 자료를 문자열로 반환
	 * 함수명	: nchk
	 * 설  명	:
	 * 2015. 7. 28.	[PUDDING] - 최초작성
	 * </PRE>
	 *
	 * @param i
	 * @return
	 */
	public static String nchk (int i) {
		return String.valueOf(i);
	}

	/**
	 * <PRE>
	 * 기  능	: NULL 또는 빈문자열 체크
	 * 함수명	: nchk
	 * 설  명	: NULL/빈문자열 인자값을 정의된 문자열로 반환
	 * 2015. 7. 28.	[PUDDING] - 최초작성
	 * </PRE>
	 *
	 * @param str - 체크 대상 문자열
	 * @param out - error에 대해 대치문자열
	 * @return
	 */
	public static String nchk (String str, String out) {
		return (str != null && !"".equals(str)) ? str : out;
	}

	/**
	 * <PRE>
	 * 기  능	: NULL 또는 빈문자열 체크
	 * 함수명	: nchk
	 * 설  명	: NULL/빈문자열 인자값을 빈문자열로 반환
	 * 2015. 7. 28.	[PUDDING] - 최초작성
	 * </PRE>
	 *
	 * @param str - 체크 대상 문자열
	 * @return
	 */
	public static String nchk (String str) {
		return nchk(str, "");
	}

}
