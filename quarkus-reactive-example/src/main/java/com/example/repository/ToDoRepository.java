package com.example.repository;

import com.example.entities.ChangeTyp;
import com.example.entities.ToDo;
import com.example.entities.ToDoEvent;
import io.smallrye.mutiny.Multi;
import io.smallrye.mutiny.Uni;
import io.smallrye.reactive.messaging.annotations.Broadcast;
import org.eclipse.microprofile.reactive.messaging.Channel;
import org.eclipse.microprofile.reactive.messaging.Emitter;
import org.hibernate.reactive.mutiny.Mutiny;

import javax.enterprise.context.ApplicationScoped;
import javax.inject.Inject;
import java.util.concurrent.CompletionStage;

@ApplicationScoped
public class ToDoRepository {

    @Inject
    @Channel("todo-stream")
    @Broadcast
    Emitter<ToDoEvent> todoChanges;

    @Inject
    Mutiny.Session mutinySession;

    public Uni<ToDo> getSingle(Integer id) {
        return mutinySession.find(ToDo.class, id);
    }

    public Multi<ToDo> get() {
        return mutinySession.createQuery("SELECT t FROM ToDo t", ToDo.class).getResults();
    }

    public Uni<Void> create(ToDo toDo) {
        if (toDo != null && toDo.getId() == null) {
            return mutinySession.persist(toDo)
                    .onItem().transform(t ->notify(toDo, ChangeTyp.CREATE))
                    .chain(mutinySession::flush);
        }
        return null;
    }

    public Uni<ToDo> update(ToDo toDo) {
        if (toDo != null) {
            return mutinySession.find(ToDo.class, toDo.getId())
                    .onItem().ifNotNull()
                    .transformToUni((ToDo entity) -> {
                        entity.setText(toDo.getText());
                        notify(entity, ChangeTyp.UPDATE);
                        return mutinySession.flush().onItem().transform(ignore -> entity);
                    });
        }
        return null;
    }

    public Uni<Void> delete(Integer id) {
        return mutinySession
                .find(ToDo.class, id)
                .onItem().ifNotNull()
                .transformToUni((ToDo entity) -> mutinySession.remove(entity)
                        .onItem().transform(t -> notify(entity, ChangeTyp.DELETE))
                        .chain(mutinySession::flush));
    }

    private CompletionStage<Void> notify(ToDo toDo, ChangeTyp changeTyp){
        try{
            return todoChanges.send(new ToDoEvent(changeTyp, toDo.getId(),toDo.getText()));
        }catch (Exception e){
            return null;
        }
    }
}
