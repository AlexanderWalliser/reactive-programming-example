package com.example.repository;

import com.example.entities.ToDo;
import io.smallrye.mutiny.Multi;
import io.smallrye.mutiny.Uni;
import io.smallrye.mutiny.operators.multi.processors.BroadcastProcessor;
import io.smallrye.reactive.messaging.annotations.Broadcast;
import org.eclipse.microprofile.reactive.messaging.Channel;
import org.eclipse.microprofile.reactive.messaging.Emitter;
import org.hibernate.reactive.mutiny.Mutiny;
import org.reactivestreams.Publisher;

import javax.enterprise.context.ApplicationScoped;
import javax.inject.Inject;
import java.util.concurrent.CompletionStage;

@ApplicationScoped
public class ToDoRepository {

    @Inject
    @Channel("todo-stream")
    @Broadcast
    Emitter<ToDo> todos;

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
                    .onItem().transform(t ->notify(toDo))
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
                        notify(entity);
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
                        .onItem().transform(t -> notify(entity))
                        .chain(mutinySession::flush));
    }

    private CompletionStage<Void> notify(ToDo toDo){
        try{
            return todos.send(toDo);
        }catch (Exception e){
            return null;
        }
    }
}
