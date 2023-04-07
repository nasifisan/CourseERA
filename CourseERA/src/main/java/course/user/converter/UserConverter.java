package course.user.converter;

import org.bson.Document;
import org.bson.types.ObjectId;
 
import course.user.model.User;

public class UserConverter {
	// convert Product Object to MongoDB Document
    // take special note of converting id String to ObjectId
    public static Document toDocument(User p) {
        Document doc = new Document("name", p.getName()).append("pass", p.getPass());
        doc.append("type", p.getType());
        
        if (p.getId() != null) {
            doc.append("_id", new ObjectId(p.getId()));
        }
        return doc;
    }
 
    // convert MongoDB Document to Product
    // take special note of converting ObjectId to String
    public static User toProduct(Document doc) {
        User p = new User();
        p.setName((String) doc.get("name"));
        p.setPass((String) doc.get("pass"));
        p.setId(((ObjectId) doc.get("_id")).toString());
        p.setType((String) doc.get("type"));
        return p;
    }
}
