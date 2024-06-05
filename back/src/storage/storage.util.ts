import { File } from "@prisma/client";

export function getUrl(file: File): string {
  return `${process.env.SERVER_URL}/storage/${file.id}`;
}

export function markdown(body: string, files: File[]): string {
  let result = body;
  for (const file of files) {
    result = result.replace(file.path, getUrl(file));
  }
  return result;
}
