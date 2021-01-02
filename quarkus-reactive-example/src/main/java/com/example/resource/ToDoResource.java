package com.example.resource;

import com.example.entities.ToDo;
import com.example.entities.ToDoEvent;
import com.example.repository.ToDoRepository;
import io.smallrye.mutiny.Multi;
import io.smallrye.mutiny.Uni;
import org.eclipse.microprofile.reactive.messaging.Channel;
import org.jboss.resteasy.annotations.SseElementType;
import org.jboss.resteasy.annotations.jaxrs.PathParam;
import org.reactivestreams.Publisher;

import javax.enterprise.context.ApplicationScoped;
import javax.inject.Inject;
import javax.ws.rs.*;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.Response;

@Path("/todos")
@ApplicationScoped
@Produces("application/json")
@Consumes("application/json")
public class ToDoResource {

    @Inject
    ToDoRepository repository;
    

    @GET
    public Multi<ToDo> get() {
        return repository.get();
    }

    @GET
    @Path("{id}")
    public Uni<ToDo> getSingle(@PathParam("id") Integer id) {
        return repository.getSingle(id);
    }

    @POST
    public Uni<Response> create(ToDo todo) {
        if (todo == null || todo.getId() != null) {
            throw new WebApplicationException("Id was invalidly set on request.", 422);
        }

        return repository.create(todo)
                .map(ignore -> Response.ok(todo).status(201).build());
    }

    @PUT
    @Path("{id}")
    public Uni<Response> update(@PathParam("id") Integer id, ToDo todo) {
        if (todo == null || todo.getText() == null) {
            throw new WebApplicationException("ToDo name was not set on request.", 422);
        }
        return repository.getSingle(id)
                .onItem()
                .ifNotNull()
                .transformToUni(entity -> repository.update(todo).onItem().transform(ignore -> Response.ok(entity).build()))
                .onItem().ifNull()
                .continueWith(Response.ok().status(404).build());
    }

    @DELETE
    @Path("{id}")
    public Uni<Response> delete(@PathParam("id") Integer id) {
        return repository.getSingle(id)
                .onItem().ifNotNull()
                .transformToUni(entity -> repository.delete(entity.getId())
                        .onItem().transform(ignore -> Response.ok().status(204).build()))
                .onItem().ifNull()
                .continueWith(Response.ok().status(404).build());
    }

    @Inject
    @Channel("todo-stream") Publisher<ToDoEvent> todoChanges;

    @GET
    @Path("/stream")
    @Produces(MediaType.SERVER_SENT_EVENTS)
    @SseElementType(MediaType.APPLICATION_JSON)
    public Publisher<ToDoEvent> stream() {
        return todoChanges;
    }
}
