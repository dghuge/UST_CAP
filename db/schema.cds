namespace ust.mycapapp.db;
using { ust.mycapapp.db.reuse as reuse } from './resuse';


entity student:reuse.address,reuse.log {
    key id: reuse.id;
    name: String(80);
    age: Integer;  
    class:Association to class
};

entity class {
    key id: reuse.id;
    name: String(30);
    specialization: String(80);
    hod:String(44);
}

