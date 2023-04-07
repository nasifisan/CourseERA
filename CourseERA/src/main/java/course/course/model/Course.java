package course.course.model;

import java.util.ArrayList;
import java.util.List;

public class Course {
	private String id;
    private String category;
    private String title;
    private String description;
    private List<String> students = new ArrayList<String>();
    private String teacher;

    public Course() {}

    public Course(String id, String category, String title, String description, String teacher, List<String> students) {
        this.id = id;
        this.category = category;
        this.title = title;
        this.description = description;
        this.teacher = teacher;
        this.students = students;
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getCategory() {
        return category;
    }

    public void setCategory(String category) {
        this.category = category;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }
    
    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }
    
    public String getTeacher() {
        return teacher;
    }

    public void setTeacher(String teacher) {
        this.teacher = teacher;
    }
    
    public List<String> getStudents() {
        return students;
    }

    public void setStudents(List<String> students) {
        this.students = students;
    }
}
