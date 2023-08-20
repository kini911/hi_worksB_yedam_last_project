package com.worksb.hi.project.service;

import java.util.List;

import javax.servlet.http.HttpSession;

import org.apache.ibatis.annotations.Param;

public interface ProjectService {
	//이진
	public int insertProject(ProjectVO projectVO);
	public int updateProject(ProjectVO projectVO);
	public ProjectVO getProjectInfo(int projectId);
	
	public int deleteProject(int projectId);
	
	
	
	
	
	
	
	
	//주현
	public List<ProjectVO> searchPrj(String memberId);
	public List<ProjectVO> selectFromCompany(int companyId,String memberId);
	public void updateStar(ProjectVO vo);
}
