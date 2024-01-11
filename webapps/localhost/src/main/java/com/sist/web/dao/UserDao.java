package com.sist.web.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import com.sist.web.db.DBManager;
import com.sist.web.model.User;

public class UserDao 
{
	private static Logger logger = LogManager.getLogger(UserDao.class);
	
	//사용자 조회
	public User userSelect(String userId)
	{
		User user = null;
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		StringBuilder sql = new StringBuilder();
		
		sql.append("SELECT USER_ID, ");
		sql.append("       NVL(USER_PWD, '') USER_PWD, ");
		sql.append("       NVL(USER_NAME, '') USER_NAME, ");
		sql.append("       NVL(USER_EMAIL, '') USER_EMAIL, ");
		sql.append("       NVL(STATUS, 'N') STATUS, ");
		sql.append("       NVL(TO_CHAR(REG_DATE, 'YYYY.MM.DD HH24:MI:SS'), '') REG_DATE ");
		sql.append("  FROM TBL_USER ");
		sql.append(" WHERE USER_ID = ? ");
		
		logger.debug("================================");
		logger.debug("UserDao userId : " + userId);
		logger.debug("================================");
		
		try
		{
			conn = DBManager.getConnection();
			pstmt = conn.prepareStatement(sql.toString());
			
			pstmt.setString(1, userId);
			
			rs = pstmt.executeQuery();
			
			logger.debug("222222222222222222222222222222222222");
			
			if(rs.next())
			{
				logger.debug("111111111111111111111111111111");
				user = new User();
				
				user.setUserId(rs.getString("USER_ID"));
				user.setUserPwd(rs.getString("USER_PWD"));
				user.setUserName(rs.getString("USER_NAME"));
				user.setUserEmail(rs.getString("USER_EMAIL"));
				user.setStatus(rs.getString("STATUS"));
				user.setRegDate(rs.getString("REG_DATE"));
			}
		}
		catch(Exception e)
		{
			logger.error("[UserDao] userSelect SQLException", e);
		}
		finally
		{
			DBManager.close(rs, pstmt, conn);
		}
		return user;
	}
	
	//아이디 존재 확인
	public int userIdSelectCount(String userId)
	{
		int count = 0;
		
		return count;
	}
	
	//사용자 등록
	public int userInsert(User user)
	{
		int count = 0;
		
		return count;
	}
	
	//사용자 정보 수정
	public int userUpdate(User user)
	{
		int count = 0;
		
		return count;
	}
}







