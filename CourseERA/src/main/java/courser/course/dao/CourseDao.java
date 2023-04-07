package courser.course.dao;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

import org.bson.Document;
import org.bson.types.ObjectId;

import com.mongodb.MongoClient;
import com.mongodb.client.FindIterable;
import com.mongodb.client.MongoCollection;
import com.mongodb.client.MongoCursor;
import com.mongodb.client.model.Filters;

import course.course.converter.CourseConverter;
import course.course.model.Course;

public class CourseDao {
	private MongoCollection<Document> coll;

    public CourseDao(MongoClient mongo) {
        this.coll = mongo.getDatabase("course").getCollection("product");
    }

    public Course create(Course p) {
        Document doc = CourseConverter.toDocument(p);
        
        this.coll.insertOne(doc);
        
        ObjectId id = (ObjectId) doc.get("_id");
        p.setId(id.toString());
        
        return p;
    }

    public void update(Course p) {
        this.coll.updateOne(Filters.eq("_id", new ObjectId(p.getId())), new Document("$set", CourseConverter.toDocument(p)));
    }

    public void delete(String id) {
        this.coll.deleteOne(Filters.eq("_id", new ObjectId(id)));
    }

    public boolean exists(String id) {
        try {
        	long  doc = this.coll.count(Filters.eq("_id", new ObjectId(id)));
            return doc > 0;
        } catch (Exception e) {
        	return false;
        }
    }
    
//    public boolean existsByName(String name) {
//        long  doc = this.coll.count(Filters.eq("name", name));
//        return doc > 0;
//    }

    public List<Course> getList() {
        List<Course> list = new ArrayList<Course>();
        MongoCursor<Document>  cursor = coll.find().iterator();

        try {
            while (cursor.hasNext()) {
                Document doc = cursor.next();
                Course p = CourseConverter.toProduct(doc);

                list.add(p);
            }
        } finally {
            cursor.close();
        }
        
        return list;
    }
    
    public List<Course> getListByUserId(String id, String feild) {
        List<Course> list = new ArrayList<Course>();
        List<String> ids = new ArrayList<String>();
        
        ids.add(id);
        
        MongoCursor<Document>  cursor;
        
        if (feild.equals("students")) {
        	cursor = coll.find(Filters.in(feild, ids)).iterator();
        } else {
        	cursor = coll.find(Filters.eq(feild, id)).iterator();
        }

        try {
            while (cursor.hasNext()) {
                Document doc = cursor.next();
                Course p = CourseConverter.toProduct(doc);

                list.add(p);
            }
        } finally {
            cursor.close();
        }
        
        return list;
    }

//    public Course getUser(String name) {
//        Document doc = this.coll.find(Filters.eq("name", name)).first();
//        return CourseConverter.toProduct(doc);
//    }
    
    public Course getCourseById(String id) {
        Document doc = this.coll.find(Filters.eq("_id", new ObjectId(id))).first();
        return CourseConverter.toProduct(doc);
    }
}
