package com.ttmsoft.toaf.util;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.nio.file.Files;
import java.nio.file.StandardCopyOption;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Iterator;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.io.FilenameUtils;
import org.apache.commons.lang.ArrayUtils;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.CellType;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.xssf.usermodel.XSSFSheet;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.mozilla.universalchardet.UniversalDetector;
import org.springframework.stereotype.Component;
import org.springframework.web.multipart.MultipartFile;

import com.ttmsoft.toaf.exception.FrameworkException;

import lombok.extern.slf4j.Slf4j;

@Component
@Slf4j
public class ExcelUtil {
	
	private final String[] allowExt = {"csv", "xls", "xlsx"};
	private final String[] allowMimeType = {
			"text/csv",
			"application/vnd.ms-excel",
			"application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"
	};
	private final String HEADERS_KEY = "headers";
	private final String DATA_KEY = "data";
	
	/**
	 * excel read 기본 메서드
	 * header row가 0번 인덱스이고 헤더가 존재할 경우 이용
	 * @param multipartFile
	 * @return 
	 * 결과 맵 내에 아래 key로 이용
	 * <br>headers: 파일의 헤더 리스트
	 * <br>data: headers에 저장된 내용을 key로 사용한 데이터맵
	 */
	public Map<String, Object> convertExcelToMap(MultipartFile multipartFile) {
		return this.convertExcelToMap(multipartFile, 0, true);
	} 
	
	/**
	 *  excel read 메서드
	 * header row의 인덱스와 헤더유무를 컨트롤 해야할 경우 이용
	 * @param multipartFile
	 * @param sheetAt
	 * @param hasHeader
	 * @return
	 * * 결과 맵 내에 아래 key로 이용
	 * <br>headers: 파일의 헤더 리스트
	 * <br>data: headers에 저장된 내용을 key로 사용한 데이터맵
	 */
	public Map<String, Object> convertExcelToMap(MultipartFile multipartFile, int sheetAt, boolean hasHeader) {
		Map<String, Object> result = new LinkedHashMap<>();
		List<String> keyList = new ArrayList<>();
		List<Map<String, Object>> dataList = new ArrayList<>();
		
		String originNm = multipartFile.getOriginalFilename();
		String mimeType = multipartFile.getContentType();
		String extention = FilenameUtils.getExtension(originNm);
		
		if(!this.isAllowedExtention(extention) || !this.isAllowedMineType(mimeType)) {
			String message = String.format("File Type is not allowed.(%s,%s)", extention, mimeType);
			throw new FrameworkException(message);
		}
		
		switch(extention) {
		case "csv":
			this.setCsv(multipartFile, sheetAt, hasHeader, result, keyList, dataList);
			break;
		case "xlsx":
			this.setXlsx(multipartFile, sheetAt, hasHeader, result, keyList, dataList);
			break;
		case "xls":
			this.setXls(multipartFile, sheetAt, hasHeader, result, keyList, dataList);
			break;
		default:
			String message = String.format("File Type is not allowed.(%s,%s)", extention, mimeType);
			throw new FrameworkException(message);
		}
		
		return result;
	}
	
	private boolean isAllowedExtention(String extention) {
		return ArrayUtils.contains(this.allowExt, extention);
	}
	
	private boolean isAllowedMineType(String mimeType) {
		return ArrayUtils.contains(allowMimeType, mimeType);
	}
	
	private List<String> getHeaderList(Row headerRow) {
		List<String> result = new ArrayList<>();
		
		headerRow.cellIterator().forEachRemaining(cell -> {
			if(cell.getCellType() != CellType.BLANK) {
				result.add(cell.getStringCellValue());
			}
		});
		
		return result;
	}
	
	private Object getCellData(Cell cell) {
		Object result = null;
		
		switch(cell.getCellType()) {
		case NUMERIC: 
			result = cell.getNumericCellValue();
			break;
		case BLANK: 
			break;
		default: result = cell.getStringCellValue();
		}
		
		return result;
	}
	
	private Map<String, Object> getDataMap(List<String> keyList, Row row) {
		Map<String, Object> result = new LinkedHashMap<>();
		int columnIdx = 0;
		Iterator<Cell> cellIterator = row.cellIterator();
		
		while(cellIterator.hasNext()) {
			Cell cell = cellIterator.next();
			result.put(keyList.get(columnIdx), this.getCellData(cell));
			
			if(keyList.size() == columnIdx+1) {
				break;
			}
			
			columnIdx++;
		}
		
		return result;
	}
	
	private void setXlsx(MultipartFile multipartFile, int sheetAt, boolean hasHeader, 
			Map<String, Object> result, List<String> keyList, List<Map<String, Object>> dataList) {
		try (
				InputStream is = multipartFile.getInputStream();
				XSSFWorkbook workbook = new XSSFWorkbook(is);
			){
			XSSFSheet sheet = workbook.getSheetAt(sheetAt);
			
			Iterator<Row> rowIterator = sheet.iterator();
			
			while(rowIterator.hasNext()) {
				Row row = rowIterator.next();
				
				// header
				if(hasHeader && row.getRowNum() == 0) {
					keyList = this.getHeaderList(row);
					result.put(this.HEADERS_KEY, keyList);
					continue;
				}
				
				// data
				dataList.add(this.getDataMap(keyList, row));
			}
			
			result.put(this.DATA_KEY, dataList);
			
		} catch (IOException e) {
			String message = String.format("Error Read Excel File.(%s)", e.getMessage());
			throw new FrameworkException(message);
		}
	}
	
	private void setXls(MultipartFile multipartFile, int sheetAt, boolean hasHeader, 
			Map<String, Object> result, List<String> keyList, List<Map<String, Object>> dataList) {
		try (
				InputStream is = multipartFile.getInputStream();
				HSSFWorkbook workbook = new HSSFWorkbook(is);
			){
			HSSFSheet sheet = workbook.getSheetAt(sheetAt);
			
			Iterator<Row> rowIterator = sheet.iterator();
			
			while(rowIterator.hasNext()) {
				Row row = rowIterator.next();
				
				// header
				if(hasHeader && row.getRowNum() == 0) {
					keyList = this.getHeaderList(row);
					result.put(this.HEADERS_KEY, keyList);
					continue;
				}
				
				// data
				dataList.add(this.getDataMap(keyList, row));
			}
			
			result.put(this.DATA_KEY, dataList);
			
		} catch (IOException e) {
			String message = String.format("Error Read Excel File.(%s)", e.getMessage());
			throw new FrameworkException(message);
		}
	}
	
	private void setCsv(MultipartFile multipartFile, int sheetAt, boolean hasHeader, 
			Map<String, Object> result, List<String> keyList, List<Map<String, Object>> dataList) {
		
		BufferedReader buf = null;
		try (
				InputStream is = multipartFile.getInputStream();
			){
			File file = File.createTempFile(String.valueOf(is.hashCode()), ".csv");
			file.deleteOnExit();
			Files.copy(is, file.toPath(), StandardCopyOption.REPLACE_EXISTING);
			
			String encoding = UniversalDetector.detectCharset(new FileInputStream(file));
		    if (encoding == null) {
				throw new FrameworkException("Error Detect CSV File Encoding.");
		    }

			buf = new BufferedReader(new InputStreamReader(new FileInputStream(file), encoding));
			
			String splitRegexp = ",(?=(?:[^\"]*\"[^\"]*\")*[^\"]*$)";
			String line = "";
			int lineIdx = 0;
			while((line = buf.readLine()) != null) {
				
				// headers
				if(hasHeader && lineIdx == 0) {
					String[] headerArr = line.split(splitRegexp);
					
					Arrays.stream(headerArr).forEach(header -> {
						keyList.add(header);
					});
					
					result.put(this.HEADERS_KEY, keyList);
					
					lineIdx++;
					continue;
				}
				
				String[] dataArr = line.split(splitRegexp);
				Map<String, Object> dataMap = new LinkedHashMap<>();
				
				for(int dataIdx = 0; dataIdx < dataArr.length; dataIdx++) {
					dataMap.put(keyList.get(dataIdx), dataArr[dataIdx]);
				}
				
				dataList.add(dataMap);
				
				lineIdx++;
			}
			
			result.put(this.DATA_KEY, dataList);
			
		} catch (IOException e) {
			String message = String.format("Error Read CSV File.(%s)", e.getMessage());
			throw new FrameworkException(message);
		} finally {
			if(buf != null) {
				try {
					buf.close();
				} catch (IOException e) {
					log.error("CSV Reader Buffer Close Error.");
				}
			}
		}
	}

}
