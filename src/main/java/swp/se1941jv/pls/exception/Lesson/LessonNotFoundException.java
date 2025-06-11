package swp.se1941jv.pls.exception.Lesson;

public class LessonNotFoundException extends RuntimeException{
    public LessonNotFoundException(String message) {
        super(message);
    }
}
