package course.course.converter;

import java.util.List;

import org.bson.Document;
import org.bson.types.ObjectId;

import course.course.model.Course;

public class CourseConverter {
	// convert Product Object to MongoDB Document
    // take special note of converting id String to ObjectId
    public static Document toDocument(Course p) {
        Document doc = new Document("category", p.getCategory());
        
        doc.append("title", p.getTitle());
        doc.append("description", p.getDescription());
        doc.append("teacher", p.getTeacher());
        doc.append("students", p.getStudents());
        
        if (p.getId() != null) {
            doc.append("_id", new ObjectId(p.getId()));
        }
        return doc;
    }
 
    // convert MongoDB Document to Product
    // take special note of converting ObjectId to String
    public static Course toProduct(Document doc) {
        Course p = new Course();
       
        p.setCategory((String) doc.get("category"));
        p.setTitle((String) doc.get("title"));
        p.setDescription((String) doc.get("description"));
        p.setId(((ObjectId) doc.get("_id")).toString());
        p.setTeacher((String) doc.get("teacher"));
        p.setStudents((List<String>) doc.get("students"));
        
//        System.out.println(p.getStudents());
        
        return p;
    }
}
