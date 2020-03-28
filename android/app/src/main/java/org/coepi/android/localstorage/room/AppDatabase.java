package org.coepi.android.localstorage.room;

import androidx.room.Database;
import androidx.room.RoomDatabase;

import org.coepi.android.localstorage.Contact;
import org.coepi.android.localstorage.Symptoms;

//You can either provide `room.schemaLocation` annotation processor argument OR set exportSchema to false.
@Database(entities = {Contact.class, Symptoms.class}, version = 1, exportSchema=false )
public abstract class AppDatabase extends RoomDatabase {
    public abstract ContactDao contactDao();
    public abstract SymptomsDao symptomsDao();
}