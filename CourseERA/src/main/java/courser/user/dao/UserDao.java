package courser.user.dao;

import java.util.ArrayList;
import java.util.List;
 
import org.bson.Document;
import org.bson.types.ObjectId;
 
import com.mongodb.MongoClient;
import com.mongodb.client.FindIterable;
import com.mongodb.client.MongoCollection;
import com.mongodb.client.MongoCursor;
import com.mongodb.client.model.Filters;
 
import course.user.converter.UserConverter;
import course.user.model.User;

public class UserDao {
	private MongoCollection<Document> coll;

    public UserDao(MongoClient mongo) {
        this.coll = mongo.getDatabase("userlist").getCollection("product");
    }

    public User create(User p) {
        Document doc = UserConverter.toDocument(p);
        
        this.coll.insertOne(doc);
        
        ObjectId id = (ObjectId) doc.get("_id");
        p.setId(id.toString());
        
        return p;
    }

    public void update(User p) {
        this.coll.updateOne(Filters.eq("_id", new ObjectId(p.getId())), new Document("$set", UserConverter.toDocument(p)));
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
    
    public boolean existsByName(String name) {
        long  doc = this.coll.count(Filters.eq("name", name));
        return doc > 0;
    }

    public List<User> getList() {
        List<User> list = new ArrayList<User>();
        MongoCursor<Document>  cursor = coll.find().iterator();

        try {
            while (cursor.hasNext()) {
                Document doc = cursor.next();
                User p = UserConverter.toProduct(doc);

                list.add(p);
            }
        } finally {
            cursor.close();
        }

        return list;
    }
    
    public List<User> getTeacherList() {
        List<User> list = new ArrayList<User>();
        MongoCursor<Document>  cursor = coll.find(Filters.eq("type", "teacher")).iterator();

        try {
            while (cursor.hasNext()) {
                Document doc = cursor.next();
                User p = UserConverter.toProduct(doc);

                list.add(p);
            }
        } finally {
            cursor.close();
        }

        return list;
    }

    public User getUser(String name) {
        Document doc = this.coll.find(Filters.eq("name", name)).first();
        return UserConverter.toProduct(doc);
    }
    
    public User getUserById(String id) {
        Document doc = this.coll.find(Filters.eq("_id", new ObjectId(id))).first();
        return UserConverter.toProduct(doc);
    }
}
