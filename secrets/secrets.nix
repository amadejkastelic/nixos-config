let
  amadejk = "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAIJC7gpWcNY0I6YCsfr1GPu2q+sODgQlBj4b6K/WGaMJxAAAABHNzaDo= amadejk@ryzen";
  users = [amadejk];

  ryzen = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIG3M55/x6au9SvHHdijwYywUeJ7G9heTPXHrrCgHQpoW root@ryzen";
  systems = [ryzen];
in {
  "spotify.age".publicKeys = [amadejk ryzen];
}
