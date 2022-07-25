-- Add migration script here
CREATE TABLE stock (
    id SERIAL PRIMARY KEY,
    product VARCHAR(100) NOT NULL,
    place VARCHAR(100) NOT NULL,
    amount INTEGER NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT now() NOT NULL
)
